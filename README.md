# Jinget Windows Service Installer Azure DevOps Extension
In the design of CI/CD pipelines, Windows service installation has always been challenging. Using Jinget Windows Service Installer, you can easily install Windows service during your pipelines.

#### Key Features of Jinget Windows Service Installer

1. Ease of use
2. Specify windows service startup type (Automatic, Manual, Disabled)
3. Specify the windows service logon credential
4. The ability to separate the service name from service display name

#### How to Use
1. Download the extension from marketplace and install it on your organization

2. Go to the desired pipeline and select the Jinget Windows Service Installer task among the task lists

3. Specify windows service common inputs
**![Windows service properties](http://jinget.ir/wp-content/uploads/2023/06/1.png "Windows service properties")
**Service Name (Required):** This is the name which is used to Start/Stop the windows service.
** Display Name (Optional):** This is the name which is displayed to the user. If this property set as empty, then *Service Name* will be used as *Display Name*.
** Path to Executable (required):** It is to specify the location of Windows service files. In most cases, the required artifacts must be downloaded to the target device before the Jinget Windows Service Installer task is added to the pipeline.
** Startup Type (required):** Specifies the Windows service startup type. It could be *Automatic*, *Manual* or *Disabled*.

4. Specify Windows Service Account Configurations
**![Windows Service Account Configuration](http://jinget.ir/wp-content/uploads/2023/06/2.png "Windows Service Account Configuration")
** Logon as(UserName) (Required):** Specify the windows service logon user accounts username. If the desired windows service needs to run under predefined accounts, such as *Network Service* then their full name should specified. For example *NT AUTHORITY\NetworkService*.
** Logon as(Password) (Optional):** Specify the windows service logon user accounts password. If the desired windows service needs to run under predefined accounts, such as *Network Service* then this input should be left empty.
