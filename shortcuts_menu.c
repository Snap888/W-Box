#include <gtk/gtk.h>
#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>
#include <unistd.h>

// Константы для улучшения читаемости
#define ICON_SIZE 64
#define BUTTONS_PER_PAGE 10
#define GRID_SPACING 5
#define WINDOW_WIDTH 280
#define WINDOW_HEIGHT 460
#define BUTTON_WIDTH 120 // Фиксированная ширина кнопки
#define BUTTON_HEIGHT 40 // Фиксированная высота кнопки
#define MAX_NAME_LENGTH 25 // Максимальная длина имени файла

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

    // Создание области для отображения текущих настроек
    GtkWidget *current_settings_frame = gtk_frame_new("Текущие настройки");
    GtkWidget *current_settings_box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 5);
    gtk_container_set_border_width(GTK_CONTAINER(current_settings_box), 10);
    gtk_container_add(GTK_CONTAINER(current_settings_frame), current_settings_box);

    // Отображение текущей версии Mobox
    GtkWidget *current_version_label = gtk_label_new(g_strdup_printf("Версия Mobox: %s", current_version ? current_version : "Не установлено"));
    gtk_box_pack_start(GTK_BOX(current_settings_box), current_version_label, FALSE, FALSE, 0);

    // Отображение текущего Driver
    if (current_driver) {
        GtkWidget *current_driver_label = gtk_label_new(g_strdup_printf("Driver: %s", current_driver));
        gtk_box_pack_start(GTK_BOX(current_settings_box), current_driver_label, FALSE, FALSE, 0);
    }

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
    DIR *dir = opendir("/data/data/com.termux/files/home/drivers");
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
    GtkWidget *label = gtk_label_new(truncated_name);
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
    snprintf(shortcuts_path, sizeof(shortcuts_path), "%s/.shortcuts", getenv("HOME"));
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
            snprintf(icon_path, sizeof(icon_path), "%s/.shortcuts/icons/%s.png", getenv("HOME"), ent->d_name);

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
