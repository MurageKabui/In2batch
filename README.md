## What is In*2*batch ?
*In2batch* is a program that helps you generate a batch code that allows to store files in a batch script quickly and easily, helping you to distribute your scripts  without their dependencies. 

**Syntax and Usage.**
To get started, make sure the program is placed in the path or in the working directory containing the CL-In2batch.exe executable and type in :
 
   `CL-In2batch.exe /?` or `CL-In2batch.exe --?` or `CL-In2batch.exe -?`
> Prints the help information to the standard output.
 
**Optional parameters Inlude :**

|*Parameters* | *Function*  |
|--|--|
/*? or --? or -?*|Print the help information to the standard output.
|*/notify*| Trigger a notification after the completion of a single file operation. Notifications are not triggered by default unless this parameter is included. Example :`CL-In2batch.exe "CLi.txt;logo.png" /notify | clip`|
|*/size*| Writes the sizes of every file in the semi-colon delimited files array parsed in the first argument . Example: `CL-In2batch.exe "CLi.txt;logo.png" /size`|


   In the following example,  we are assuming that our working directory has  *"**File1.csv**" "**File2.txt**" "**Logo.ico**" *and a directory  named*  "**Bin**"* which has 3 more files inside.""

     CL-In2batch.exe "File1.csv;Logo.ico;Bin" /notify | Clip


> The above command generates batch code for **File1.csv** ,**File2.txt** , **Logo.ico** and **all the 3 files** present in the directory **Bin** present in our working directory. After each file operation a notification is triggered. The code is directly piped to our clipboard.

    CL-In2batch.exe "E:\Batchscripts\Bin" >>MybatchScript.bat
> The above command generates the batch code to embed all the files present in the folder  **E:\Batchscripts\Dependencies\\**  and redirect the code to a file called **MybatchScript.bat** 


> Code preview:
  ![enter image description here](https://lh3.googleusercontent.com/rYm04FjO0gRqwN4zEBWPZMzbqZr2GNF1CNKN6Ka0vgu0yjwnQfX3ojndWZqQVXg5a_GNbDJFlUI "Generated code preview")

### Errorlevel / Returns

     0 - Success / No Error.
     1 - One or more files failed (Mostly due to Invalid File/Path)
     3 - CertUtil error.

## 


For more plugins visit www.thebateam.org .
