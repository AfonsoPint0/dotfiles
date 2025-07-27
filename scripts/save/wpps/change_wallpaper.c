#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <gtk/gtk.h>
#include <ctype.h>

int ends_with_ignore_case(const char *str, const char *suffix) {
    if (!str || !suffix) return 0;
    size_t lenstr = strlen(str);
    size_t lensuffix = strlen(suffix);
    if (lensuffix > lenstr) return 0;

    for (size_t i = 0; i < lensuffix; i++) {
        if (tolower(str[lenstr - lensuffix + i]) != tolower(suffix[i])) {
            return 0;
        }
    }
    return 1;
}

int is_image_file(const char *filename) {
    return ends_with_ignore_case(filename, ".jpg") ||
           ends_with_ignore_case(filename, ".jpeg") ||
           ends_with_ignore_case(filename, ".png") ||
           ends_with_ignore_case(filename, ".gif") ||
           ends_with_ignore_case(filename, ".bmp") ||
           ends_with_ignore_case(filename, ".tiff") ||
           ends_with_ignore_case(filename, ".webp");
}

static void on_frame_clicked(GtkGestureClick *gesture, int n_press, double x, double y, gpointer user_data) {
    	GtkWidget *widget = GTK_WIDGET(gtk_event_controller_get_widget(GTK_EVENT_CONTROLLER(gesture)));
 	
    	const gchar *image_path = g_object_get_data(G_OBJECT(widget), "image-path");

    	if (image_path != NULL) {
        	gchar *command = g_strdup_printf("./updateIt.sh \"%s\"", image_path);

        	if (!g_spawn_command_line_async(command, NULL)) {
            		g_printerr("Failed to execute script: %s\n", command);
        	}

		GApplication *app = G_APPLICATION(user_data);
		g_application_quit(G_APPLICATION(app));
        	
		g_free(command);
    	} else {
        	g_printerr("No image path attached to widget.\n");
    	}

	
}


static void activate(GtkApplication *app, gpointer user_data) {

	g_object_set(app, "handles-close", FALSE, NULL);
	// gtk window
	GtkWidget *window = gtk_application_window_new(app);
	gtk_window_set_title(GTK_WINDOW(window), "wpp_mngr");	
    	gtk_window_set_default_size(GTK_WINDOW(window), 1200, 00);
	
	gtk_widget_set_opacity(GTK_WIDGET(window), 0.8);
	gtk_window_set_resizable(GTK_WINDOW(window), FALSE);
    	g_signal_connect(window, "destroy", G_CALLBACK(gtk_window_destroy), window);

	// css
	GtkCssProvider *provider = gtk_css_provider_new ();
	gtk_css_provider_load_from_path (provider, "style.css");
	GdkDisplay *display = gdk_display_get_default (); 
  	gtk_style_context_add_provider_for_display (display, GTK_STYLE_PROVIDER (provider), GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);

	// gtk box & grid
	GtkWidget *center_box = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0);
	gtk_widget_set_hexpand(center_box, TRUE);
    	gtk_widget_set_halign(center_box, GTK_ALIGN_CENTER);
	
	GtkWidget *grid = gtk_grid_new();
	gtk_widget_set_size_request(grid, 1000, -1);
    	gtk_grid_set_row_spacing(GTK_GRID(grid), 10);
    	gtk_grid_set_column_spacing(GTK_GRID(grid), 10);

	// open folder
	const char *folder = "./imgs";
	DIR *dir = opendir(folder);
	if(dir == NULL) {
		perror("opendir");
		return;
	}
	
	struct dirent *entry;
	int count = 0;
	while ((entry = readdir(dir)) != NULL) {
        	// Skip "." and ".."
        	if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
            		continue;

		if(is_image_file(entry->d_name)) {
			char fullpath[1024];
            		snprintf(fullpath, sizeof(fullpath), "%s/%s", folder, entry->d_name);

            		GError *error = NULL;
            		GdkPixbuf *pixbuf = gdk_pixbuf_new_from_file(fullpath, &error);
			if (!pixbuf) {
    				g_warning("Failed to load image %s: %s", fullpath, error->message);
    				g_error_free(error);
    				continue;
			}
			
			// Convert pixbuf to texture (GdkPaintable)
			GdkTexture *texture = gdk_texture_new_for_pixbuf(pixbuf);
			GtkWidget *image = gtk_image_new_from_paintable(GDK_PAINTABLE(texture));
			
			// frame
			GtkWidget *frame = gtk_frame_new(NULL);
			gtk_widget_set_name(frame, "frame");
		        gtk_widget_set_size_request(frame, 400, 350);
        		gtk_frame_set_child(GTK_FRAME(frame), image);
			
			// click
			g_object_set_data_full(G_OBJECT(frame), "image-path", g_strdup(fullpath), g_free);
			GtkGesture *click = gtk_gesture_click_new();
    			g_signal_connect(click, "pressed", G_CALLBACK(on_frame_clicked), app);
    			gtk_widget_add_controller(frame, GTK_EVENT_CONTROLLER(click));	

			// Clean up
			g_object_unref(pixbuf);
			g_object_unref(texture);

            		int row = count / 4;
            		int col = count % 4;
            		gtk_grid_attach(GTK_GRID(grid), frame, col, row, 1, 1);
			count++;
		}
    	}


	closedir(dir);
	gtk_box_append(GTK_BOX(center_box), grid);
 	gtk_window_set_child(GTK_WINDOW(window), center_box);
	gtk_window_present(GTK_WINDOW(window));
}

int main(int argc, char *argv[]) {
    GtkApplication *app = gtk_application_new("com.example.imagegrid", G_APPLICATION_DEFAULT_FLAGS);
    g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);
    int status = g_application_run(G_APPLICATION(app), argc, argv);
    g_object_unref(app);
    return status;
}

