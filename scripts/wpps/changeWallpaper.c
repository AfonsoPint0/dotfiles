#include <gtk/gtk.h>

static void print_hello (GtkWidget *widget, gpointer data)
{
	g_print ("Hello World\n");
  
// close - pass window
//	GtkWindow * window = GTK_WINDOW(data);
//	gtk_window_close(window);

}

static void activate(GtkApplication *app, gpointer user_data)
{
  	GtkWidget *window;
  	GtkWidget *button;

  	window = gtk_application_window_new (app);
  	gtk_window_set_title (GTK_WINDOW (window), "ChangeWallpaper");
  	gtk_window_set_default_size (GTK_WINDOW (window), 1200, 600);
	gtk_window_set_resizable(GTK_WINDOW(window), FALSE);

  	button = gtk_button_new_with_label ("Hello World");
  	g_signal_connect (button, "clicked", G_CALLBACK (print_hello), NULL);
  	gtk_window_set_child (GTK_WINDOW (window), button);

  	gtk_window_present (GTK_WINDOW (window));
}

int main(int argc,char **argv)
{
	GtkApplication *app;
  	int status;

  	app = gtk_application_new ("org.gtk.example", G_APPLICATION_DEFAULT_FLAGS);
  	g_signal_connect (app, "activate", G_CALLBACK (activate), NULL);
  	status = g_application_run (G_APPLICATION (app), argc, argv);
  	g_object_unref (app);

  	return status;
}

