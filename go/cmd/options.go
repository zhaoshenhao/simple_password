package main

import (
	"github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/plugins/shared_preferences"
	"github.com/go-flutter-desktop/plugins/path_provider"
)

var options = []flutter.Option{
	flutter.WindowInitialDimensions(800, 1280),
	flutter.AddPlugin(&shared_preferences.SharedPreferencesPlugin{
		VendorName:      "myOrganizationOrUsername",
		ApplicationName: "myApplicationName",
	}),
	flutter.AddPlugin(&path_provider.PathProviderPlugin{
		VendorName:      "myOrganizationOrUsername",
		ApplicationName: "myApplicationName",
	}),
}
