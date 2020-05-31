#ifdef WINDOWS
#include <direct.h>
#define GetCurrentDir _getcwd
#else
#include <unistd.h>
#define GetCurrentDir getcwd
#endif
#include <windows.h> // ShellExecute()
#include <iostream>
#include <fstream>
#include <string>
// PENDING............. 
using namespace std;

bool is_file_exist(const char *fileName)
{
    std::ifstream infile(fileName);
    return infile.good();
}
// The directory path returned by native GetCurrentDirectory() no end backslash

std::string get_current_dir() {
   char buff[FILENAME_MAX]; //create string buffer to hold path
   GetCurrentDir( buff, FILENAME_MAX );
   string current_working_dir(buff);
   return current_working_dir;
}

int main()
{
    // Create a text string, which is used to output the text file
    string myText;
    // Read from the text file
    // cout << get_current_dir() << endl;
    // ShellExecute (NULL, "open", "C:\\WINDOWS\\system32\\cmd.exe", "/c \"Echo hello world", NULL, SW_SHOW );


    if (is_file_exist("filename.txt")) {
        ifstream MyReadFile("filename.txt");
        // char cmdres= system("Certutil.exe -encode 'F:\CPP tutorial\CL-in2batch\filename.txt' 'F:\CPP tutorial\CL-in2batch\enc.txt'");

        cout << "cmd command : " << cmdres << endl;
        // Use a while loop together with the getline() function to read the file line by line
        while (getline (MyReadFile, myText)) {
          // Output the text from the file
          cout << "Echo " << myText << endl;
        }
        // Close the file
        MyReadFile.close();
    } else {
        string errmessage;
        errmessage = "The file does not exist in ";
        cout << errmessage.append(get_current_dir())<< endl;
    }
    return 0;
}
