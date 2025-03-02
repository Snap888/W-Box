#include <gtk/gtk.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <unistd.h>
#include <glib.h> // Для работы с GList

// Константы для улучшения читаемости
#define ICON_SIZE 64
#define BUTTONS_PER_PAGE 10
#define GRID_SPACING 5
#define WINDOW_WIDTH 280
#define WINDOW_HEIGHT 460
#define BUTTON_WIDTH 120 // Фиксированная ширина кнопки
#define BUTTON_HEIGHT 40 // Фиксированная высота кнопки
#define MAX_NAME_LENGTH 25 // Максимальная длина имени файла
#define ICON_SIZE_SMALL 16 // Размер маленьких иконок

// Константы для путей
#define SHORTCUTS_DIR ".shortcuts" // Папка с ярлыками (относительно домашней директории)
#define ICONS_DIR ".shortcuts/icons" // Папка с иконками (относительно домашней директории)
#define DRIVERS_DIR "/data/data/com.termux/files/home/drivers" // Папка с драйверами
#define RENDER_DIR "render" // Папка с файлами Render (относительно домашней директории)
#define SETTINGS_FILE "settings.conf" // Файл настроек (можно указать полный путь)
#define ICONS_SMALL_DIR "ico" // Папка с маленькими иконками (относительно домашней директории)
#define BOX64_DIR "/data/data/com.termux/files/home/box64" // Папка с версиями Box64

// Константы для цветов
#define COLOR_SELECTED "green" // Цвет для выбранных параметров
#define COLOR_DEFAULT "black" // Цвет по умолчанию

// Константы для языков
#define LANGUAGES {"Русский", "Английский"} // Доступные языки
#define LANGUAGE_CODES {"ru_RU.utf8", "en_US.utf8"} // Соответствующие коды языков

// Функция для обрезки строки до 25 символов
char *truncate_name(const char *name) {
    if (strlen(name) <= MAX_NAME_LENGTH) {
        return g_strdup(name); // Возвращаем копию строки, если она не превышает лимит
    } else {
        char *truncated = g_malloc(MAX_NAME_LENGTH + 4); // +4 для "..." и нулевого символа
        strncpy(truncated, name, MAX_NAME_LENGTH);
        strcpy(truncated + MAX_NAME_LENGTH, "..."); // Добавляем многоточие
        return truncated;
    }
}

// Функция для дополнения строки пробелами до 25 символов
char *pad_name(const char *name) {
    char *padded = g_malloc(MAX_NAME_LENGTH + 1); // +1 для нулевого символа
    strncpy(padded, name, MAX_NAME_LENGTH);
    padded[MAX_NAME_LENGTH] = '\0';

    // Дополняем пробелами, если строка короче 25 символов
    for (int i = strlen(padded); i < MAX_NAME_LENGTH; i++) {
        padded[i] = ' ';
    }
    padded[MAX_NAME_LENGTH] = '\0';

    return padded;
}

// Функция для создания белого квадрата
GtkWidget *create_white_square(int size) {
    GdkPixbuf *pixbuf = gdk_pixbuf_new(GDK_COLORSPACE_RGB, FALSE, 8, size, size);
    if (!pixbuf) {
        fprintf(stderr, "Ошибка создания белого квадрата\n");
        return NULL;
    }
    gdk_pixbuf_fill(pixbuf, 0xFFFFFFFF); // Белый цвет
    GtkWidget *image = gtk_image_new_from_pixbuf(pixbuf);
    g_object_unref(pixbuf);
    return image;
}

// Функция для загрузки и масштабирования иконки
GtkWidget *load_scaled_icon(const char *path, int width, int height) {
    GdkPixbuf *pixbuf = gdk_pixbuf_new_from_file(path, NULL);
    if (!pixbuf) {
        return NULL;
    }
    GdkPixbuf *scaled_pixbuf = gdk_pixbuf_scale_simple(pixbuf, width, height, GDK_INTERP_BILINEAR);
    g_object_unref(pixbuf);
    if (!scaled_pixbuf) {
        return NULL;
    }
    GtkWidget *image = gtk_image_new_from_pixbuf(scaled_pixbuf);
    g_object_unref(scaled_pixbuf);
    return image;
}

// Функция для запуска файла
void on_file_clicked(GtkButton *button, gpointer user_data) {
    const char *file_path = (const char *)user_data;
    printf("Запуск файла: %s\n", file_path);

    // Запуск файла
    if (fork() == 0) {
        execl("/bin/bash", "bash", file_path, NULL);
        exit(0);
    }

    // Закрытие окна
    GtkWidget *window = gtk_widget_get_toplevel(GTK_WIDGET(button));
    gtk_window_close(GTK_WINDOW(window));

    // Освобождение памяти
    g_free(user_data);
}

// Функция для чтения текущих настроек из файла
char *get_setting_value(const char *file_path, const char *setting_name) {
    FILE *file = fopen(file_path, "r");
    if (!file) {
        perror("Ошибка открытия файла для чтения");
        return NULL;
    }

    char *value = NULL;
    char line[256];
    while (fgets(line, sizeof(line), file)) {
        if (strstr(line, setting_name) == line) {
            char *equal_sign = strchr(line, '=');
            if (equal_sign) {
                equal_sign++;
                value = g_strdup(equal_sign);
                value[strcspn(value, "\n")] = '\0'; // Удаление символа новой строки
                break;
            }
        }
    }

    fclose(file);
    return value;
}

// Функция для обновления значения настройки в файле
void update_setting_value(const char *file_path, const char *setting_name, const char *new_value) {
    FILE *file = fopen(file_path, "r");
    if (!file) {
        perror("Ошибка открытия файла для чтения");
        return;
    }

    // Чтение файла в буфер
    fseek(file, 0, SEEK_END);
    long file_size = ftell(file);
    fseek(file, 0, SEEK_SET);

    char *buffer = malloc(file_size + 1);
    fread(buffer, 1, file_size, file);
    buffer[file_size] = '\0';
    fclose(file);

    // Поиск и замена строки с настройкой
    char *setting_start = strstr(buffer, setting_name);
    if (setting_start) {
        char *setting_end = strchr(setting_start, '\n');
        if (!setting_end) setting_end = buffer + file_size;

        // Создание нового содержимого файла
        char *new_buffer = malloc(file_size + 50); // Запас для новой строки
        int prefix_len = setting_start - buffer;
        int suffix_len = file_size - (setting_end - buffer);

        memcpy(new_buffer, buffer, prefix_len);
        sprintf(new_buffer + prefix_len, "%s=%s\n", setting_name, new_value);
        memcpy(new_buffer + prefix_len + strlen(setting_name) + strlen(new_value) + 2, setting_end, suffix_len);

        // Запись обновлённого содержимого в файл
        file = fopen(file_path, "w");
        if (!file) {
            perror("Ошибка открытия файла для записи");
            free(buffer);
            free(new_buffer);
            return;
        }
        fwrite(new_buffer, 1, prefix_len + strlen(setting_name) + strlen(new_value) + 2 + suffix_len, file);
        fclose(file);

        free(new_buffer);
    } else {
        // Если настройка не найдена, добавляем её в конец файла
        file = fopen(file_path, "a");
        if (!file) {
            perror("Ошибка открытия файла для записи");
            free(buffer);
            return;
        }
        fprintf(file, "%s=%s\n", setting_name, new_value);
        fclose(file);
    }

    free(buffer);
}

// Обработчик изменения версии Mobox
void on_version_changed(GtkComboBox *combo, gpointer user_data) {
    const char *file_path = (const char *)user_data;
    const char *version = gtk_combo_box_text_get_active_text(GTK_COMBO_BOX_TEXT(combo));

    if (version) {
        printf("Изменение версии Mobox на %s для файла: %s\n", version, file_path);
        update_setting_value(file_path, "BOX_VERS", version);
        g_free((gpointer)version);
    }
}

// Обработчик изменения Driver
void on_driver_changed(GtkComboBox *combo, gpointer user_data) {
    const char *file_path = (const char *)user_data;
    const char *driver = gtk_combo_box_text_get_active_text(GTK_COMBO_BOX_TEXT(combo));

    if (driver) {
        char driver_file[256];
        snprintf(driver_file, sizeof(driver_file), "%s.weg", driver);
        printf("Изменение Driver на %s для файла: %s\n", driver_file, file_path);
        update_setting_value(file_path, "TURNIP_WOW", driver_file);
        g_free((gpointer)driver);
    }
}

// Функция для сканирования папки render и получения списка файлов .WEG
GList *get_render_files() {
    GList *render_files = NULL;
    char render_path[256];
    snprintf(render_path, sizeof(render_path), "%s/%s", getenv("HOME"), RENDER_DIR);

    DIR *dir = opendir(render_path);
    if (!dir) {
        perror("Ошибка открытия директории render");
        return NULL;
    }

    struct dirent *ent;
    while ((ent = readdir(dir)) != NULL) {
        if (ent->d_type == DT_REG && strstr(ent->d_name, ".WEG")) {
            char *file_name = g_strdup(ent->d_name);
            file_name[strlen(file_name) - 4] = '\0'; // Убираем .WEG
            render_files = g_list_append(render_files, file_name);
        }
    }
    closedir(dir);

    return render_files;
}

// Обработчик изменения Render
void on_render_changed(GtkComboBox *combo, gpointer user_data) {
    const char *file_path = (const char *)user_data;
    const char *render = gtk_combo_box_text_get_active_text(GTK_COMBO_BOX_TEXT(combo));

    if (render) {
        char render_file[256];
        snprintf(render_file, sizeof(render_file), "%s.WEG", render);
        printf("Изменение Render на %s для файла: %s\n", render_file, file_path);
        update_setting_value(file_path, "DXVK_WOW", render_file);
        g_free((gpointer)render);
    }
}

// Функция для сканирования папки box64 и получения списка файлов .WEG
GList *get_box64_files() {
    GList *box64_files = NULL;
    DIR *dir = opendir(BOX64_DIR);
    if (!dir) {
        perror("Ошибка открытия директории box64");
        return NULL;
    }

    struct dirent *ent;
    while ((ent = readdir(dir)) != NULL) {
        if (ent->d_type == DT_REG && strstr(ent->d_name, ".WEG")) {
            char *file_name = g_strdup(ent->d_name);
            box64_files = g_list_append(box64_files, file_name);
        }
    }
    closedir(dir);

    return box64_files;
}

// Обработчик изменения версии Box64
void on_box64_changed(GtkComboBox *combo, gpointer user_data) {
    const char *file_path = (const char *)user_data;
    const char *box64_version = gtk_combo_box_text_get_active_text(GTK_COMBO_BOX_TEXT(combo));

    if (box64_version) {
        printf("Изменение версии Box64 на %s для файла: %s\n", box64_version, file_path);
        update_setting_value(file_path, "BOX_WOW", box64_version);
        g_free((gpointer)box64_version);
    }
}

// Обработчик изменения языка
void on_language_changed(GtkComboBox *combo, gpointer user_data) {
    const char *file_path = (const char *)user_data;
    const char *language = gtk_combo_box_text_get_active_text(GTK_COMBO_BOX_TEXT(combo));

    if (language) {
        const char *language_codes[] = LANGUAGE_CODES;
        const char *languages[] = LANGUAGES;

        for (int i = 0; i < sizeof(languages) / sizeof(languages[0]); i++) {
            if (strcmp(language, languages[i]) == 0) {
                printf("Изменение языка на %s для файла: %s\n", language_codes[i], file_path);
                update_setting_value(file_path, "LANG_BOX", language_codes[i]);
                break;
            }
        }
        g_free((gpointer)language);
    }
}

// Функция для создания строки с иконкой и текстом
GtkWidget *create_icon_label(const char *icon_name, const char *text, const char *color) {
    GtkWidget *hbox = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, GRID_SPACING);

    // Загрузка иконки
    char icon_path[256];
    snprintf(icon_path, sizeof(icon_path), "%s/%s/%s.png", getenv("HOME"), ICONS_SMALL_DIR, icon_name);
    GtkWidget *icon = load_scaled_icon(icon_path, ICON_SIZE_SMALL, ICON_SIZE_SMALL);
    if (icon) {
        gtk_box_pack_start(GTK_BOX(hbox), icon, FALSE, FALSE, 0);
    }

    // Создание текста с использованием Pango Markup
    GtkWidget *label = gtk_label_new(NULL); // Создаём пустую метку
    gtk_label_set_markup(GTK_LABEL(label), g_strdup_printf("<span color='%s'>%s</span>", color, text));
    gtk_box_pack_start(GTK_BOX(hbox), label, FALSE, FALSE, 0);

    return hbox;
}

// Обработчик нажатия на кнопку "Применить"
void on_apply_clicked(GtkButton *button, gpointer user_data) {
    GtkWidget *window = gtk_widget_get_toplevel(GTK_WIDGET(button));
    gtk_window_close(GTK_WINDOW(window));
}

// Обработчик нажатия на кнопку "Отмена"
void on_cancel_clicked(GtkButton *button, gpointer user_data) {
    GtkWidget *window = gtk_widget_get_toplevel(GTK_WIDGET(button));
    gtk_window_close(GTK_WINDOW(window));
}

// Функция для открытия окна настроек Display
void on_display_settings_clicked(GtkButton *button, gpointer user_data) {
    const char *file_path = (const char *)user_data;
    printf("Открытие настроек Display для файла: %s\n", file_path);

    // Создание окна настроек Display
    GtkWidget *display_window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(display_window), "Настройки Display");
    gtk_window_set_default_size(GTK_WINDOW(display_window), 400, 300);
    gtk_window_set_position(GTK_WINDOW(display_window), GTK_WIN_POS_CENTER);

    // Создание контейнера для настроек Display
    GtkWidget *vbox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 10);
    gtk_container_add(GTK_CONTAINER(display_window), vbox);

    // Добавление настроек Display
    GtkWidget *fps_label = gtk_label_new("Блокировка FPS:");
    gtk_box_pack_start(GTK_BOX(vbox), fps_label, FALSE, FALSE, 0);

    GtkWidget *fps_combo = gtk_combo_box_text_new();
    gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(fps_combo), "30 FPS");
    gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(fps_combo), "60 FPS");
    gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(fps_combo), "120 FPS");
    gtk_box_pack_start(GTK_BOX(vbox), fps_combo, FALSE, FALSE, 0);

    GtkWidget *resolution_label = gtk_label_new("Разрешение экрана:");
    gtk_box_pack_start(GTK_BOX(vbox), resolution_label, FALSE, FALSE, 0);

    GtkWidget *resolution_combo = gtk_combo_box_text_new();
    gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(resolution_combo), "1920x1080");
    gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(resolution_combo), "1280x720");
    gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(resolution_combo), "800x600");
    gtk_box_pack_start(GTK_BOX(vbox), resolution_combo, FALSE, FALSE, 0);

    GtkWidget *stretch_check = gtk_check_button_new_with_label("Растянуть экран");
    gtk_box_pack_start(GTK_BOX(vbox), stretch_check, FALSE, FALSE, 0);

    GtkWidget *hud_label = gtk_label_new("Настройки HUD:");
    gtk_box_pack_start(GTK_BOX(vbox), hud_label, FALSE, FALSE, 0);

    GtkWidget *hud_combo = gtk_combo_box_text_new();
    gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(hud_combo), "Минимальный");
    gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(hud_combo), "Стандартный");
    gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(hud_combo), "Расширенный");
    gtk_box_pack_start(GTK_BOX(vbox), hud_combo, FALSE, FALSE, 0);

    GtkWidget *theme_label = gtk_label_new("Тема оформления:");
    gtk_box_pack_start(GTK_BOX(vbox), theme_label, FALSE, FALSE, 0);

    GtkWidget *theme_combo = gtk_combo_box_text_new();
    gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(theme_combo), "Светлая");
    gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(theme_combo), "Тёмная");
    gtk_box_pack_start(GTK_BOX(vbox), theme_combo, FALSE, FALSE, 0);

    GtkWidget *wallpaper_label = gtk_label_new("Настройка Обоев:");
    gtk_box_pack_start(GTK_BOX(vbox), wallpaper_label, FALSE, FALSE, 0);

    GtkWidget *wallpaper_combo = gtk_combo_box_text_new();
    gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(wallpaper_combo), "Обои 1");
    gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(wallpaper_combo), "Обои 2");
    gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(wallpaper_combo), "Обои 3");
    gtk_box_pack_start(GTK_BOX(vbox), wallpaper_combo, FALSE, FALSE, 0);

    // Добавление кнопок "Применить" и "Отмена"
    GtkWidget *button_box = gtk_button_box_new(GTK_ORIENTATION_HORIZONTAL);
    gtk_box_set_spacing(GTK_BOX(button_box), 5);

    GtkWidget *apply_button = gtk_button_new_with_label("Применить");
    GtkWidget *cancel_button = gtk_button_new_with_label("Отмена");

    g_signal_connect(apply_button, "clicked", G_CALLBACK(on_apply_clicked), NULL);
    g_signal_connect(cancel_button, "clicked", G_CALLBACK(on_cancel_clicked), NULL);

    gtk_box_pack_end(GTK_BOX(button_box), apply_button, FALSE, FALSE, 0);
    gtk_box_pack_end(GTK_BOX(button_box), cancel_button, FALSE, FALSE, 0);

    gtk_box_pack_end(GTK_BOX(vbox), button_box, FALSE, FALSE, 0);

    // Отображение окна настроек Display
    gtk_widget_show_all(display_window);
}

// Функция для открытия окна настроек
void on_settings_clicked(GtkButton *button, gpointer user_data) {
    const char *file_path = (const char *)user_data;
    printf("Открытие настроек для файла: %s\n", file_path);

    // Создание окна настроек
    GtkWidget *settings_window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(settings_window), "Настройки");
    gtk_window_set_default_size(GTK_WINDOW(settings_window), 400, 300);
    gtk_window_set_position(GTK_WINDOW(settings_window), GTK_WIN_POS_CENTER);

    // Создание контейнера для настроек
    GtkWidget *vbox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 10);
    gtk_container_add(GTK_CONTAINER(settings_window), vbox);

    // Чтение текущих настроек
    char *current_version = get_setting_value(file_path, "BOX_VERS");
    char *current_driver = get_setting_value(file_path, "TURNIP_WOW");
    char *current_render = get_setting_value(file_path, "DXVK_WOW");
    char *current_box64 = get_setting_value(file_path, "BOX_WOW");
    char *current_language = get_setting_value(file_path, "LANG_BOX");

    // Создание области для отображения текущих настроек
    GtkWidget *current_settings_frame = gtk_frame_new("Текущие настройки");
    GtkWidget *current_settings_box = gtk_grid_new();
    gtk_grid_set_row_spacing(GTK_GRID(current_settings_box), GRID_SPACING);
    gtk_grid_set_column_spacing(GTK_GRID(current_settings_box), GRID_SPACING);
    gtk_container_set_border_width(GTK_CONTAINER(current_settings_box), 10);
    gtk_container_add(GTK_CONTAINER(current_settings_frame), current_settings_box);

    // Отображение текущей версии Mobox
    GtkWidget *current_version_icon_label = create_icon_label("mobox", "Версия Mobox", COLOR_DEFAULT);
    GtkWidget *current_version_label = gtk_label_new(NULL); // Создаём пустую метку
    gtk_label_set_markup(GTK_LABEL(current_version_label), g_strdup_printf("<span color='%s'>%s</span>", COLOR_SELECTED, current_version ? current_version : "Не установлено"));
    gtk_grid_attach(GTK_GRID(current_settings_box), current_version_icon_label, 0, 0, 1, 1);
    gtk_grid_attach(GTK_GRID(current_settings_box), current_version_label, 1, 0, 1, 1);

    // Отображение текущего Driver
    GtkWidget *current_driver_icon_label = create_icon_label("driver", "Driver", COLOR_DEFAULT);
    GtkWidget *current_driver_label = gtk_label_new(NULL); // Создаём пустую метку
    gtk_label_set_markup(GTK_LABEL(current_driver_label), g_strdup_printf("<span color='%s'>%s</span>", COLOR_SELECTED, current_driver ? current_driver : "Не установлено"));
    gtk_grid_attach(GTK_GRID(current_settings_box), current_driver_icon_label, 0, 1, 1, 1);
    gtk_grid_attach(GTK_GRID(current_settings_box), current_driver_label, 1, 1, 1, 1);

    // Отображение текущего Render
    GtkWidget *current_render_icon_label = create_icon_label("render", "Render", COLOR_DEFAULT);
    GtkWidget *current_render_label = gtk_label_new(NULL); // Создаём пустую метку
    gtk_label_set_markup(GTK_LABEL(current_render_label), g_strdup_printf("<span color='%s'>%s</span>", COLOR_SELECTED, current_render ? current_render : "Не установлено"));
    gtk_grid_attach(GTK_GRID(current_settings_box), current_render_icon_label, 0, 2, 1, 1);
    gtk_grid_attach(GTK_GRID(current_settings_box), current_render_label, 1, 2, 1, 1);

    // Отображение текущей версии Box64
    GtkWidget *current_box64_icon_label = create_icon_label("box64", "Версия Box64", COLOR_DEFAULT);
    GtkWidget *current_box64_label = gtk_label_new(NULL); // Создаём пустую метку
    gtk_label_set_markup(GTK_LABEL(current_box64_label), g_strdup_printf("<span color='%s'>%s</span>", COLOR_SELECTED, current_box64 ? current_box64 : "Не установлено"));
    gtk_grid_attach(GTK_GRID(current_settings_box), current_box64_icon_label, 0, 3, 1, 1);
    gtk_grid_attach(GTK_GRID(current_settings_box), current_box64_label, 1, 3, 1, 1);

    // Отображение текущего языка
    GtkWidget *current_language_icon_label = create_icon_label("language", "Язык", COLOR_DEFAULT);
    GtkWidget *current_language_label = gtk_label_new(NULL); // Создаём пустую метку
    gtk_label_set_markup(GTK_LABEL(current_language_label), g_strdup_printf("<span color='%s'>%s</span>", COLOR_SELECTED, current_language ? current_language : "Не установлено"));
    gtk_grid_attach(GTK_GRID(current_settings_box), current_language_icon_label, 0, 4, 1, 1);
    gtk_grid_attach(GTK_GRID(current_settings_box), current_language_label, 1, 4, 1, 1);

    // Добавление области текущих настроек в окно
    gtk_box_pack_start(GTK_BOX(vbox), current_settings_frame, FALSE, FALSE, 0);

    // Создание области для изменения настроек
    GtkWidget *settings_frame = gtk_frame_new("Изменить настройки");
    GtkWidget *settings_box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 5);
    gtk_container_set_border_width(GTK_CONTAINER(settings_box), 10);
    gtk_container_add(GTK_CONTAINER(settings_frame), settings_box);

    // Добавление выпадающего списка для изменения версии Mobox
    GtkWidget *version_label = gtk_label_new("Версия Mobox:");
    gtk_box_pack_start(GTK_BOX(settings_box), version_label, FALSE, FALSE, 0);

    GtkWidget *version_combo = gtk_combo_box_text_new();
    gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(version_combo), "WOW64");
    gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(version_combo), "X86");
    gtk_box_pack_start(GTK_BOX(settings_box), version_combo, FALSE, FALSE, 0);

    // Установка текущего значения версии
    if (current_version) {
        if (strcmp(current_version, "WOW64") == 0) {
            gtk_combo_box_set_active(GTK_COMBO_BOX(version_combo), 0);
        } else if (strcmp(current_version, "X86") == 0) {
            gtk_combo_box_set_active(GTK_COMBO_BOX(version_combo), 1);
        }
        g_free(current_version);
    }

    // Подключение обработчика изменения версии
    g_signal_connect(version_combo, "changed", G_CALLBACK(on_version_changed), g_strdup(file_path));

    // Добавление выпадающего списка для изменения Driver
    GtkWidget *driver_label = gtk_label_new("Driver:");
    gtk_box_pack_start(GTK_BOX(settings_box), driver_label, FALSE, FALSE, 0);

    GtkWidget *driver_combo = gtk_combo_box_text_new();
    DIR *dir = opendir(DRIVERS_DIR);
    if (dir) {
        struct dirent *ent;
        while ((ent = readdir(dir)) != NULL) {
            if (ent->d_type == DT_REG && strstr(ent->d_name, ".weg")) {
                char driver_name[256];
                strncpy(driver_name, ent->d_name, strlen(ent->d_name) - 4); // Убираем .weg
                driver_name[strlen(ent->d_name) - 4] = '\0';
                gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(driver_combo), driver_name);
            }
        }
        closedir(dir);
    }
    gtk_box_pack_start(GTK_BOX(settings_box), driver_combo, FALSE, FALSE, 0);

    // Установка текущего значения Driver
    if (current_driver) {
        char driver_name[256];
        strncpy(driver_name, current_driver, strlen(current_driver) - 4); // Убираем .weg
        driver_name[strlen(current_driver) - 4] = '\0';

        // Получаем модель из ComboBox
        GtkTreeModel *model = gtk_combo_box_get_model(GTK_COMBO_BOX(driver_combo));
        if (model) {
            GtkTreeIter iter;
            gboolean valid = gtk_tree_model_get_iter_first(model, &iter);
            int index = 0;

            // Ищем совпадение в списке
            while (valid) {
                gchar *item_text;
                gtk_tree_model_get(model, &iter, 0, &item_text, -1);

                if (item_text && strcmp(item_text, driver_name) == 0) {
                    gtk_combo_box_set_active(GTK_COMBO_BOX(driver_combo), index);
                    g_free(item_text);
                    break;
                }

                if (item_text) {
                    g_free(item_text);
                }

                valid = gtk_tree_model_iter_next(model, &iter);
                index++;
            }
        }
        g_free(current_driver);
    }

    // Подключение обработчика изменения Driver
    g_signal_connect(driver_combo, "changed", G_CALLBACK(on_driver_changed), g_strdup(file_path));

    // Добавление выпадающего списка для изменения Render
    GtkWidget *render_label = gtk_label_new("Render:");
    gtk_box_pack_start(GTK_BOX(settings_box), render_label, FALSE, FALSE, 0);

    GtkWidget *render_combo = gtk_combo_box_text_new();
    GList *render_files = get_render_files();
    if (render_files) {
        for (GList *iter = render_files; iter != NULL; iter = iter->next) {
            gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(render_combo), (const char *)iter->data);
        }
        g_list_free_full(render_files, g_free);
    }
    gtk_box_pack_start(GTK_BOX(settings_box), render_combo, FALSE, FALSE, 0);

    // Установка текущего значения Render
    if (current_render) {
        GtkTreeModel *model = gtk_combo_box_get_model(GTK_COMBO_BOX(render_combo));
        if (model) {
            GtkTreeIter iter;
            gboolean valid = gtk_tree_model_get_iter_first(model, &iter);
            int index = 0;

            // Ищем совпадение в списке
            while (valid) {
                gchar *item_text;
                gtk_tree_model_get(model, &iter, 0, &item_text, -1);

                if (item_text && strcmp(item_text, current_render) == 0) {
                    gtk_combo_box_set_active(GTK_COMBO_BOX(render_combo), index);
                    g_free(item_text);
                    break;
                }

                if (item_text) {
                    g_free(item_text);
                }

                valid = gtk_tree_model_iter_next(model, &iter);
                index++;
            }
        }
        g_free(current_render);
    }

    // Подключение обработчика изменения Render
    g_signal_connect(render_combo, "changed", G_CALLBACK(on_render_changed), g_strdup(file_path));

    // Добавление выпадающего списка для изменения Box64
    GtkWidget *box64_label = gtk_label_new("Версия Box64:");
    gtk_box_pack_start(GTK_BOX(settings_box), box64_label, FALSE, FALSE, 0);

    GtkWidget *box64_combo = gtk_combo_box_text_new();
    GList *box64_files = get_box64_files();
    if (box64_files) {
        for (GList *iter = box64_files; iter != NULL; iter = iter->next) {
            gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(box64_combo), (const char *)iter->data);
        }
        g_list_free_full(box64_files, g_free);
    }
    gtk_box_pack_start(GTK_BOX(settings_box), box64_combo, FALSE, FALSE, 0);

    // Установка текущего значения Box64
    if (current_box64) {
        GtkTreeModel *model = gtk_combo_box_get_model(GTK_COMBO_BOX(box64_combo));
        if (model) {
            GtkTreeIter iter;
            gboolean valid = gtk_tree_model_get_iter_first(model, &iter);
            int index = 0;

            // Ищем совпадение в списке
            while (valid) {
                gchar *item_text;
                gtk_tree_model_get(model, &iter, 0, &item_text, -1);

                if (item_text && strcmp(item_text, current_box64) == 0) {
                    gtk_combo_box_set_active(GTK_COMBO_BOX(box64_combo), index);
                    g_free(item_text);
                    break;
                }

                if (item_text) {
                    g_free(item_text);
                }

                valid = gtk_tree_model_iter_next(model, &iter);
                index++;
            }
        }
        g_free(current_box64);
    }

    // Подключение обработчика изменения Box64
    g_signal_connect(box64_combo, "changed", G_CALLBACK(on_box64_changed), g_strdup(file_path));

    // Добавление выпадающего списка для изменения языка
    GtkWidget *language_label = gtk_label_new("Язык:");
    gtk_box_pack_start(GTK_BOX(settings_box), language_label, FALSE, FALSE, 0);

    GtkWidget *language_combo = gtk_combo_box_text_new();
    const char *languages[] = LANGUAGES;
    for (int i = 0; i < sizeof(languages) / sizeof(languages[0]); i++) {
        gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(language_combo), languages[i]);
    }
    gtk_box_pack_start(GTK_BOX(settings_box), language_combo, FALSE, FALSE, 0);

    // Установка текущего значения языка
    if (current_language) {
        const char *language_codes[] = LANGUAGE_CODES;
        for (int i = 0; i < sizeof(language_codes) / sizeof(language_codes[0]); i++) {
            if (strcmp(current_language, language_codes[i]) == 0) {
                gtk_combo_box_set_active(GTK_COMBO_BOX(language_combo), i);
                break;
            }
        }
        g_free(current_language);
    }

    // Подключение обработчика изменения языка
    g_signal_connect(language_combo, "changed", G_CALLBACK(on_language_changed), g_strdup(file_path));

    // Добавление кнопки "Display"
    GtkWidget *display_button = gtk_button_new_with_label("Display");
    g_signal_connect(display_button, "clicked", G_CALLBACK(on_display_settings_clicked), g_strdup(file_path));
    gtk_box_pack_start(GTK_BOX(settings_box), display_button, FALSE, FALSE, 0);

    // Добавление кнопок "Применить" и "Отмена"
    GtkWidget *button_box = gtk_button_box_new(GTK_ORIENTATION_HORIZONTAL);
    gtk_box_set_spacing(GTK_BOX(button_box), 5);

    GtkWidget *apply_button = gtk_button_new_with_label("Применить");
    GtkWidget *cancel_button = gtk_button_new_with_label("Отмена");

    g_signal_connect(apply_button, "clicked", G_CALLBACK(on_apply_clicked), NULL);
    g_signal_connect(cancel_button, "clicked", G_CALLBACK(on_cancel_clicked), NULL);

    gtk_box_pack_end(GTK_BOX(button_box), apply_button, FALSE, FALSE, 0);
    gtk_box_pack_end(GTK_BOX(button_box), cancel_button, FALSE, FALSE, 0);

    gtk_box_pack_end(GTK_BOX(vbox), button_box, FALSE, FALSE, 0);

    // Добавление области изменения настроек в окно
    gtk_box_pack_start(GTK_BOX(vbox), settings_frame, FALSE, FALSE, 0);

    // Отображение окна настроек
    gtk_widget_show_all(settings_window);
}

// Функция для создания страницы с кнопками
GtkWidget *create_page(GtkNotebook *notebook, int page_number) {
    GtkWidget *page = gtk_grid_new();
    gtk_grid_set_row_spacing(GTK_GRID(page), GRID_SPACING);
    gtk_grid_set_column_spacing(GTK_GRID(page), GRID_SPACING);
    gtk_notebook_append_page(notebook, page, gtk_label_new(g_strdup_printf("Страница %d", page_number + 1)));
    return page;
}

// Функция для добавления кнопки на страницу
void add_button_to_page(GtkWidget *page, const char *file_name, const char *file_path, const char *icon_path, int *file_count) {
    // Обрезаем имя файла до 25 символов
    char *truncated_name = truncate_name(file_name);

    // Дополняем имя файла пробелами до 25 символов
    char *padded_name = pad_name(truncated_name);

    // Создание горизонтального контейнера для иконки и текста
    GtkWidget *hbox = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, GRID_SPACING);

    // Добавление иконки или белого квадрата
    GtkWidget *image;
    if (access(icon_path, F_OK) == 0) {
        image = load_scaled_icon(icon_path, ICON_SIZE, ICON_SIZE);
    } else {
        image = create_white_square(ICON_SIZE);
    }
    if (image) {
        gtk_box_pack_start(GTK_BOX(hbox), image, FALSE, FALSE, 0);
    }

    // Добавление текста
    GtkWidget *label = gtk_label_new(padded_name);
    gtk_label_set_ellipsize(GTK_LABEL(label), PANGO_ELLIPSIZE_END); // Добавляем многоточие, если текст не помещается
    gtk_box_pack_start(GTK_BOX(hbox), label, FALSE, FALSE, 0);

    // Создание кнопки для запуска файла
    GtkWidget *file_button = gtk_button_new();
    gtk_widget_set_size_request(file_button, BUTTON_WIDTH, BUTTON_HEIGHT); // Фиксированный размер кнопки
    gtk_container_add(GTK_CONTAINER(file_button), hbox);

    // Создание кнопки с шестерёнкой
    GtkWidget *settings_button = gtk_button_new();
    GtkWidget *settings_image = gtk_image_new_from_icon_name("preferences-system", GTK_ICON_SIZE_BUTTON); // Используем стандартную иконку GTK
    gtk_container_add(GTK_CONTAINER(settings_button), settings_image);

    // Создание горизонтального контейнера для кнопок
    GtkWidget *button_box = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, GRID_SPACING);
    gtk_box_pack_start(GTK_BOX(button_box), file_button, TRUE, TRUE, 0);
    gtk_box_pack_start(GTK_BOX(button_box), settings_button, FALSE, FALSE, 0);

    // Добавление кнопок в сетку
    int row = (*file_count % BUTTONS_PER_PAGE) / 2;
    int col = (*file_count % BUTTONS_PER_PAGE) % 2;
    gtk_grid_attach(GTK_GRID(page), button_box, col, row, 1, 1);

    // Подключение сигналов
    g_signal_connect(file_button, "clicked", G_CALLBACK(on_file_clicked), g_strdup(file_path));
    g_signal_connect(settings_button, "clicked", G_CALLBACK(on_settings_clicked), g_strdup(file_path));

    (*file_count)++;

    // Освобождение памяти
    g_free(truncated_name);
    g_free(padded_name);
}

int main(int argc, char *argv[]) {
    GtkWidget *window;
    GtkWidget *notebook;
    DIR *dir;
    struct dirent *ent;
    char shortcuts_path[256];
    char icons_path[256];
    char file_path[512];
    char icon_path[512];
    int file_count = 0;
    int page_count = 0;

    gtk_init(&argc, &argv);

    // Создание главного окна
    window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(window), "Меню ярлыков");
    gtk_window_set_default_size(GTK_WINDOW(window), WINDOW_WIDTH, WINDOW_HEIGHT);
    gtk_window_set_resizable(GTK_WINDOW(window), FALSE); // Фиксированный размер окна
    gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);
    g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);

    // Создание закладок
    notebook = gtk_notebook_new();
    gtk_container_add(GTK_CONTAINER(window), notebook);

    // Открытие директории с ярлыками
    snprintf(shortcuts_path, sizeof(shortcuts_path), "%s/%s", getenv("HOME"), SHORTCUTS_DIR);
    dir = opendir(shortcuts_path);
    if (dir == NULL) {
        perror("Ошибка открытия директории ~/.shortcuts/");
        return 1;
    }

    // Чтение файлов из директории
    while ((ent = readdir(dir)) != NULL) {
        if (ent->d_type == DT_REG) { // Только обычные файлы
            // Полный путь к файлу
            snprintf(file_path, sizeof(file_path), "%s/%s", shortcuts_path, ent->d_name);

            // Полный путь к иконке
            snprintf(icon_path, sizeof(icon_path), "%s/%s/%s.png", getenv("HOME"), ICONS_DIR, ent->d_name);

            // Создание новой страницы, если текущая заполнена
            if (file_count % BUTTONS_PER_PAGE == 0) {
                create_page(GTK_NOTEBOOK(notebook), page_count);
                page_count++;
            }

            // Получение текущей страницы
            GtkWidget *page = gtk_notebook_get_nth_page(GTK_NOTEBOOK(notebook), page_count - 1);

            // Добавление кнопки на страницу
            add_button_to_page(page, ent->d_name, file_path, icon_path, &file_count);
        }
    }
    closedir(dir);

    // Отображение всех элементов
    gtk_widget_show_all(window);

    // Запуск основного цикла GTK
    gtk_main();

    return 0;
}
