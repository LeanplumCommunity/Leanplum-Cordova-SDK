# com.telerik.leanplum

Leanplum enables mobile teams to quickly go from insight to action using the lean cycle of releasing, analyzing and optimizing content and messaging. Start using our fully integrated solution in minutes!
The plugin defines a global `LeanPlum` object, which defines various operations to perform A/B tests for an application.

Although the object is in the global scope, it is not available until after the _deviceready_ event.

    document.addEventListener("deviceready", onDeviceReady, false);
    function onDeviceReady() {
        console.log(device.cordova);
    }



## Getting Started

You need to obtain the app ID, development and production keys to add the plugin in your app. Once done, use the following line to enable debugging in the following way:

    LeanPlum.enableDebugging();


Next, start LeanPlum in the following way:

    Leanplum.start(function(){
        // Do Your Thing.
    })

Based on debugging enabled. It will use either the production or development key for a given app ID.

## Events and States: Tracking User Behavior

Leanplum automatically logs session and user information for you. If you want more detailed information, such as how much ad revenue you made, or how long your users played each level of your game, you can set that up with Events and States.

An event is anything that can occur in your app. Events include clicking on a link, sharing, purchasing, killing enemies, etc. All events are timestamped according to when they occur. Thus, it is not advisable to log too many (thousands) of events, as each one will have to be sent to our server.

A parameter is a piece of data associated with an event or state. You can supply parameters as a dictionary along with events and states. Here are some reports you can run with parameters:

* Filter reports by event parameter values
* Group metrics by distinct event parameter values (creates a bar graph + table).
Example: Show me my top purchased items.
* Group metrics by ranges of event parameter values (creates a histogram + table).
Example: Show me the distribution of purchase prices.
Example: Show me the distribution of points scored.
* Create custom metrics for numeric parameter values, like totals and averages. Example: For a purchase event, track and average revenue and the amount of currency bought per user.


        Leanplum.track("Eats");
        Leanplum.track("Likes", { "postId": post.Id });


## In-App Messaging & Push Notifications

In-App Messaging

Leanplum comes with a number of in-app messaging templates, including alerts, confirmation screens, popups, and full-screen interstitials. They are open source, so you can customize them however you want, and you can even create your own templates. There is no setup required for in-app messaging. However, if you want to modify or create new ones, read on.

On the dashboard, you can set in-app messages to automatically appear when a certain events occur or when the app starts. There's no additional coding needed.

### Push Notifications

Push Notifications sent using the Triggered delivery mode requires no additional setup. For Immediate, Scheduled, and Manual delivery modes, you need to enable push notifications inside your app and upload your keys to Leanplum.

1. Login to the iOS provisioning portal.
2. In the Identifiers > App IDs, select your app, click Edit, and enable Push Notifications.
3. Click Create Certificate for each of the Development and Production certificates and follow the onscreen instructions. You should not reuse existing certificates so that we can track delivery failures properly.
4. Download your new certificate files from your browser. Open the files on your computer, which will launch Keychain.
5. In Keychain, select the new certificates, expand them to view the private key, and then right click to export them as .p12 files. You must enter a password.
Once you have your .p12 files, upload them to Leanplum.
6. Configure your app to use push notifications.

         
        document.addEventListener('deviceready', function () {
            Leanplum.start(function(){
                Leanplum.registerPush({
                    "badge": "true",
                    "sound": "true",
                    "alert": "true",
                    "callback": "app.onNotificationReceived"
                });
            });
        });
     
        app.onNotificationReceived(e){
              alert(JSON.stringify(e));
        }
         


## Supported Platforms

iOS
