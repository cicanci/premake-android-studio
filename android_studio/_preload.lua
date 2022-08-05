local p = premake

function create_asset_packs(wks) 
    -- create asset packs
    for name, value in pairs(wks.assetpacks) do
        for _, item in ipairs(value) do
            gradle = "// auto-generated by premake-android-studio\n"
            gradle = (gradle .. "apply plugin: 'com.android.asset-pack'\n")
            gradle = (gradle .. "assetPack {\n")
            gradle = (gradle .. "    packName = '" .. name .. "'\n")
            gradle = (gradle .. "    dynamicDelivery {\n")
            gradle = (gradle .. "        deliveryType = " .. "'" .. item .. "'\n")
            gradle = (gradle .. "    }\n")
            gradle = (gradle .. "}\n")
            io.writefile(wks.location .. "/" .. name .. "/build.gradle", gradle)
        end
    end
end

function create_gradle_wrapper(wks) 
    -- create gradle wrapper
    if wks.gradlewrapper then
        gradle = "// auto-generated by premake-android-studio\n"
        for _, item in ipairs(wks.gradlewrapper) do
            gradle = (gradle .. item .. "\n")
        end
        io.writefile(wks.location .. "/gradle/wrapper/gradle-wrapper.properties", gradle)
    end
end

-- Premake extensions
newaction {
    trigger     = "android-studio",
    shortname   = "Android Studio",
    description = "Generate Android Studio Gradle Files",
    toolset     = "clang",

    valid_kinds = { 
        "ConsoleApp", 
        "WindowedApp", 
        "SharedLib", 
        "StaticLib", 
        "Makefile", 
        "Utility", 
        "None" 
    },
    valid_languages = { "C", "C++", "Java" },
    valid_tools = {
        cc = { "clang" },
    },
            
    -- function overloads
    onWorkspace = function(wks)
        p.generate(wks, "settings.gradle", p.modules.android_studio.generate_workspace_settings)
        p.generate(wks, "build.gradle",  p.modules.android_studio.generate_workspace)
        p.generate(wks, "gradle.properties", p.modules.android_studio.generate_gradle_properties)
        if wks.runconfigoptions and wks.runconfigmodule then
            p.generate(wks, "./../.idea/runConfigurations/" .. wks.name .. ".xml", p.modules.android_studio.generate_run_configuration)
        end
        create_asset_packs(wks)
        create_gradle_wrapper(wks)
    end,

    onProject = function(prj)
        if prj.androidmanifest == nil then
            p.generate(prj, prj.name .. "/src/main/AndroidManifest.xml",  p.modules.android_studio.generate_manifest)
        end
        p.generate(prj, prj.name .. "/build.gradle",  p.modules.android_studio.generate_project)
        p.generate(prj, prj.name .. "/CMakeLists.txt",  p.modules.android_studio.generate_cmake_lists)
        p.generate(prj, prj.name .. "/google-services.json",  p.modules.android_studio.generate_googleservices)
    end
}

p.api.register 
{
    name = "androidabis",
    scope = "project",
    kind = "list:string",
    allowed = {
        "armeabi",
        "armeabi-v7a",
        "arm64-v8a",
        "x86",
        "x86_64"
    }
}

p.api.register 
{
    name = "gradleversion",
    scope = "workspace",
    kind = "string"
}

p.api.register 
{
    name = "gradlewrapper",
    scope = "workspace",
    kind = "list:string"
}

p.api.register
{
    name = "androidbuildsettings",
    scope = "config",
    kind = "list:string"
}

p.api.register
{
    name = "androiddependenciesworkspace",
    scope = "workspace",
    kind = "list:string"
}

p.api.register 
{
    name = "androidprojectdependencies",
    scope = "project",
    kind = "list:string"
}

p.api.register
{
    name = "androidplugins",
    scope = "project",
    kind = "list:string"
}

p.api.register 
{
    name = "androiddependencies",
    scope = "project",
    kind = "list:string"
}

p.api.register
{
    name = "androidrepositories",
    scope = "workspace",
    kind = "list:string"
}

p.api.register 
{
    name = "gradleproperties",
    scope = "workspace",
    kind = "list:string"
}

p.api.register 
{
    name = "androidsdkversion",
    scope = "project",
    kind = "string"
}

p.api.register 
{
    name = "androidminsdkversion",
    scope = "project",
    kind = "string"
}

p.api.register 
{
    name = "androidmanifest",
    scope = "project",
    kind = "file"
}

p.api.register 
{
    name = "archivedirs",
    scope = "project",
    kind = "list:directory"
}

p.api.register 
{
    name = "assetdirs",
    scope = "project",
    kind = "list:directory"
}

p.api.register
{
    name = "androidkeystorefile",
    scope = "project",
    kind = "file"
}

p.api.register 
{
    name = "androidkeyalias",
    scope = "project",
    kind = "string"
}

p.api.register 
{
    name = "androidkeypassword",
    scope = "project",
    kind = "string"
}

p.api.register 
{
    name = "androidstorepassword",
    scope = "project",
    kind = "string"
}

p.api.register 
{
    name = "androidversioncode",
    scope = "project",
    kind = "string"
}

p.api.register 
{
    name = "androidversionname",
    scope = "project",
    kind = "string"
}

p.api.register 
{
    name = "androidndkpath",
    scope = "project",
    kind = "string"
}

p.api.register 
{
    name = "assetpacks",
    scope = "workspace",
    kind = "key-array"
}

p.api.register 
{
    name = "assetpackdependencies",
    scope = "project",
    kind = "list:string"
}

p.api.register
{
    name = "runconfigmodule",
    scope = "workspace",
    kind = "string"
}

p.api.register
{
    name = "runconfigoptions",
    scope = "workspace",
    kind = "key-array"
}

p.api.register
{
    name = "apkoutputpath",
    scope = "project",
    kind = "string"
}

p.api.register
{
    name = "aaroutputpath",
    scope = "project",
    kind = "string"
}

p.api.register
{
    name = "androidappid",
    scope = "project",
    kind = "string"
}

p.api.register
{
    name = "androidcmake",
    scope = "project",
    kind = "list:string"
}
