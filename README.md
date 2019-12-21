![GitHub file size in bytes](https://img.shields.io/github/size/Kabue-Murage/In2batch-Commandline-Version-/CL-In2batch.exe?color=Orange&label=File%20size&style=plastic%20size) [![GitHub license](https://img.shields.io/github/license/Kabue-Murage/In2batch-Commandline-Version-?style=plastic%20size)](https://github.com/Kabue-Murage/In2batch-Commandline-Version-/blob/master/LICENSE) 

## What is In*2*batch ?
*In2batch* is a program that helps you generate a batch code that allows to store files in a batch script quickly and easily, allowing you to distribute your scripts without their dependencies. 

 **Dependencies/Requirements**

| |   |
|--|--|
|**CertUtil.exe** | -_Certutil_.exe Command-line program installed as part of Windows OS Certificate Services. You can use _Certutil_.exe to dump and display certification authority (CA) configuration information, configure Certificate Services, backup and restore CA components, and verify certificates, key pairs, and certificate chains. |

#
**Syntax and Usage.**
The program must be present in the `%path%` environment  or in the working directory containing the CL-In2batch.exe executable file. 
 
   `CL-In2batch.exe /?` or `CL-In2batch.exe --?` or `CL-In2batch.exe -?`
> The above command will print the help information to command prompt.
 
**Optional parameters Inlude :**

|*Parameters* | *Function*  |
|--|--|
/*? or --? or -?*|- Print the help information to the standard output. Example:  `CL-In2batch.exe /?`
|/version|- Print the current/build version number to the standard output. Example : `CL-In2batch.exe -ver`
|*/notify*|- Trigger a notification after  the completion of each file operation. Notifications are not triggered by default unless this parameter is included. Example :`CL-In2batch.exe "myfolderA;logo.png" -notify`|
|/funcname| - This parameter allows you to customize the function ID in your batch code. Example: `CL-In2batch.exe "myfolderA;Myicon.ico" -funcname "create my files"` will result to a DOS callable function called `:create_my_files`. Leaving out this parameter unused will force the program to generate a unique number instead.  
|*/size*| - Writes the sizes of every **file** in the semi-colon delimited  files array parsed in the first argument .Folders are ignored! Example: `CL-In2batch.exe "CLi.txt;logo.png" -size`|
||
#


   In the following example,  we are assuming that our working directory has  *"**File1.csv**" "**File2.txt**" "**Logo.ico**" *and a directory  named*  "**Bin**"* which has 3 more files inside.""

     CL-In2batch.exe "File1.csv;Logo.ico;Bin" /notify | Clip

> The above command generates batch code for **File1.csv** ,**File2.txt** , **Logo.ico** and **all the 3 files** present in the directory **Bin**. After each file operation a notification is triggered at the bottom right corner of our screen. The generated code is directly piped to our clipboard after the operation is complete.
#
    CL-In2batch.exe "E:\Batchscripts\Bin" >>MybatchScript.bat
> The above command generates the batch code to embed all the files present in the folder  **E:\Batchscripts\Bin**  and redirect the code to a file called **MybatchScript.bat** 



#
### Errorlevel / Returns

     0 - Success / No Error.
     1 - One or more files failed (Mostly due to Invalid File/Path)
     3 - CertUtil error.

## 


For more plugins visit www.thebateam.org .
