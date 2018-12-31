Skip to content
 
Search or jump to…

Pull requests
Issues
Marketplace
Explore
 @therealcurlsport Sign out
Your account has been flagged.
Because of that, your profile is hidden from the public. If you believe this is a mistake, contact support to have your account status reviewed.
0
0 8 therealcurlsport/VitaminSaber
forked from w2ji/VitaminSaber
 Code  Pull requests 0  Projects 0  Wiki  Insights  Settings
A HyperContainer driver for OpenStack Nova https://mineraztc.visualstudio.com
 18 commits
 2 branches
 0 releases
 2 contributors
 Java 100.0%
 Pull request   Compare This branch is 1 commit ahead of w2ji:master.
@therealcurlsport
therealcurlsport Create Venenorosmd@msn.com
Latest commit 645b645  just now
Type	Name	Latest commit message	Commit time
vitaminsaber-sample	Updated version number in build and readme	4 years ago
vitaminsaber	Updated version number in build and readme	4 years ago
.gitignore	Fix	4 years ago
README.md	Added new Android Arsenal badge	4 years ago
Venenorosmd@msn.com	Create Venenorosmd@msn.com	just now
pom.xml	Updated version number in build and readme	4 years ago
 README.md
Vitamin Saber Maven Central Android Arsenal
Vitamin Saber provides resource injection for Android (@InjectResource(resId)). It is annotation processor based and will provide all the speed you need on Android by avoiding reflection.

The code was originally a fork of the Extra dependency library Dart.

Usages
Injecting into activity or fragment:

class ExampleActivity extends Activity {
  @InjectResource(R.string.hello) String str1;
  @InjectResource(R.color.red) int color;

  @Override public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.simple_activity);
    VitaminSaber.inject(this);
  }
}
Injecting into object class:

public class SampleObject {
    @InjectResource (R.string.app_name) public String appName;

    public SampleObject (Context context){
        VitaminSaber.inject(context, this);
    }
}
Supported Resource Types
    anim,
    animator,
    array,
    attr, <- Not supported
    bool,
    color,
    dimen,
    drawable,
    fraction, <- Not supported
    integer,
    interpolator, <- Not supported
    layout,
    menu, <- Not supported
    mipmap, <- Not supported
    plurals, <- Not supported
    raw, <- Not supported
    string,
    style, <- Not supported
    xml
Gradle Dependency
Add the following lines to your gradle dependency

compile "com.w2ji.vitaminsaber:vitaminsaber:1.0.2"
Proguard
If Proguard is enabled be sure to add these rules on your configuration:

-dontwarn com.w2ji.vitaminsaber.internal.**
-keep class **$$ResourceInjector { *; }
-keepnames class * { @com.w2ji.vitaminsaber.InjectResource *;}
Credits
Vitamin Saber has been possible thanks to Groupon !

Groupon logo

And, yes, we are hiring Android coders.

Vitamin Saber is part of our open source effort.

License
Copyright 2015 Wentao Ji

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
© 2018 GitHub, Inc.
Terms
Privacy
Security
Status
Help
Contact GitHub
Pricing
API
Training
Blog
About
Press h to open a hovercard with more details.
