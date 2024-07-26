//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <objectbox_flutter_libs/objectbox_flutter_libs_plugin.h>
#include <platform_device_id_windows/platform_device_id_windows_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  ObjectboxFlutterLibsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ObjectboxFlutterLibsPlugin"));
  PlatformDeviceIdWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PlatformDeviceIdWindowsPlugin"));
}
