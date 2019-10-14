using Uno;
using Uno.UX;
using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;
using Fuse;
using Fuse.Triggers;
using Fuse.Controls;
using Fuse.Controls.Native;
using Fuse.Controls.Native.Android;

 namespace AppCenter {
    [ForeignInclude(Language.Java,
					"android.app.Activity",
					"android.content.Intent",
					"android.net.Uri",
					"android.os.Bundle",
                    "com.microsoft.appcenter.AppCenter",
     "com.microsoft.appcenter.analytics.Analytics",
     "com.microsoft.appcenter.crashes.Crashes")]
       [Require("Gradle.Dependency.Compile", "com.microsoft.appcenter:appcenter-analytics:2.3.0")]
        [Require("Gradle.Dependency.Compile", "com.microsoft.appcenter:appcenter-crashes:2.3.0")] 
    public class Initialize : Behavior {
      
		
		
      
        public Initialize () {
            debug_log "Constructor";
           
            Fuse.Platform.Lifecycle.EnteringForeground += OnEnteringForeground;
            if ((Fuse.Platform.Lifecycle.State == Fuse.Platform.ApplicationState.Foreground)
                || (Fuse.Platform.Lifecycle.State == Fuse.Platform.ApplicationState.Interactive)
                ) {
                _foreground = true;
            }
        }

        void OnEnteringForeground(Fuse.Platform.ApplicationState newState)
        {
            _foreground = true;
            Init();
        }

        static bool _foreground = false;
        static bool _inited = false;
        void Init() {
            debug_log "Init";
             debug_log "Key AppCenter ";
             debug_log ""+ _key;
            if (_inited)
                return;
            if (_key == null) {
            return;
            }
            if (!_foreground)
                return;
            _inited = true;
            if defined(mobile) 
                InitImpl(_key);
        }

       

        [Require("Gradle.Dependency.Compile","com.microsoft.appcenter:appcenter-analytics:2.3.0")]
        [Require("Gradle.Dependency.Compile","com.microsoft.appcenter:appcenter-crashes:2.3.0")]
        [Foreign(Language.Java)]
        extern(Android) void InitImpl(string key)
        @{
            //android.util.Log.d("AppCenterKey", key);
            AppCenter.start(com.fuse.Activity.getRootActivity().getApplication(),key,Analytics.class,Crashes.class);
        @}

        static string _key;
        public string Key {
            get { return _key; } 
            set { 
            _key = value;
            Init();
            }
        }

    }
 }