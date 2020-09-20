package main

import (
	"github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/plugins/shared_preferences"
	"github.com/go-flutter-desktop/plugins/path_provider"
	"github.com/go-flutter-desktop/plugins/package_info"
	"github.com/miguelpruivo/flutter_file_picker/go"
)

var options = []flutter.Option{
	flutter.WindowInitialDimensions(400, 640),
	flutter.AddPlugin(&shared_preferences.SharedPreferencesPlugin{
		VendorName:      "com.syspole",
		ApplicationName: "simple_password",
	}),
	flutter.AddPlugin(&path_provider.PathProviderPlugin{
		VendorName:      "com.syspole",
		ApplicationName: "simple_password",
	}),
	flutter.AddPlugin(&package_info.PackageInfoPlugin{}),
	flutter.AddPlugin(&file_picker.FilePickerPlugin{}),
}
