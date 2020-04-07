---


---

<p><img src="https://img.shields.io/github/size/Kabue-Murage/In2batch-Commandline-Version-/CL-In2batch.dll?color=Orange&amp;label=File%20size&amp;style=plastic%20size" alt="GitHub file size in bytes"> <a href="https://github.com/Kabue-Murage/In2batch-Commandline-Version-/blob/master/LICENSE"><img src="https://img.shields.io/github/license/Kabue-Murage/In2batch-Commandline-Version-?style=plastic%20size" alt="GitHub license"></a><br>
<br></p>
<p>Win32 console application that helps you generate a batch code that allows to store files in a batch script easily, letting you to distribute your scripts without their dependencies, and recreate them on run.</p>
<h3 id="dependenciesrequirements">Dependencies/Requirements</h3>

<table>
<thead>
<tr>
<th></th>
<th></th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>CertUtil.exe</strong></td>
<td>CertUtil (CL) is a program installed as part of Windows OS Certificate Services. You can use <em>Certutil</em> to dump and display certification authority (CA) configuration information, configure Certificate Services, backup and restore CA components, and verify certificates, key pairs, and certificate chains. In this case , CertUtil is used to encode files to base64.</td>
</tr>
</tbody>
</table><h3 id="syntax-and-usage.">Syntax and Usage.</h3>
<p>The program must be present in the <mark><code>path</code></mark> environment  or in the working directory containing the CL-In2batch.dll executable file.  <br><br>
• The first argument should contain a FQPN (Full qualified path name) to the file you want to embed in your script. It may be multiple file paths delimited using a semi colon ( ; ) for  a multiple file operation.</p>
<p><code>CL-In2batch.dll /?</code> or <code>CL-In2batch.dll --?</code> or <code>CL-In2batch.dll -?</code></p>
<blockquote>
<p>The  above command will print the help information to the standard output  on command prompt .</p>
</blockquote>
<p><strong>Optional parameters Include :</strong></p>

<table>
<thead>
<tr>
<th><em>Parameters/Flag</em></th>
<th><em>Function</em></th>
</tr>
</thead>
<tbody>
<tr>
<td>/<em>? or --? or -?</em></td>
<td>Print the help information to the standard output. Example: <br> &gt; <code>CL-In2batch.dll /?</code></td>
</tr>
<tr>
<td>/version</td>
<td>Print the current/build version number to the standard output. Example : <br> &gt; <code>CL-In2batch.dll -ver</code></td>
</tr>
<tr>
<td><em>/notify</em></td>
<td>Including this flag causes a notification after the completion of each file operation. Notifications are not triggered by default unless this flag is included. Example :<br> &gt; <code>CL-In2batch.dll "folderABC;EULA.rtf" -notify</code></td>
</tr>
<tr>
<td>/funcname</td>
<td>This parameter allows you to customize the function ID in your batch code. Example :<br> &gt; <code>CL-In2batch.dll "EULA.rtf" -funcname "create eula"</code> <br> will result to a DOS callable function called <code>:create_eula</code>. Leaving out this parameter unused will force the program to generate a unique number instead.</td>
</tr>
<tr>
<td><em>/size</em></td>
<td>Prints the sizes of every <strong>file</strong> in the semi-colon delimited  files array parsed in the first argument .Folders are ignored! Example: <br> &gt; <code>CL-In2batch.dll "EULA.rtf;License.rtf" -size</code></td>
</tr>
</tbody>
</table><p><strong>Other flags :</strong></p>

<table>
<thead>
<tr>
<th><em>Flag</em></th>
<th><em>Function</em></th>
</tr>
</thead>
<tbody>
<tr>
<td><em>-srg</em></td>
<td>Including this flag causes the start region remark to be displayed in the generated batch code. <br> <code>================= Start Region In2Batch CL-Generator ==================</code> <br> Example: <br> <code>CL-In2batch.dll "ABC.txt;ABC.exe" -srg -erg /notify</code></td>
</tr>
<tr>
<td>-erg</td>
<td>Including this flag causes the end region remark to be displayed in the generated batch code. <br> <code>================ End Region In2Batch CL-Generator =================</code></td>
</tr>
<tr>
<td></td>
<td></td>
</tr>
</tbody>
</table><p>In the following example,  we are assuming that our working directory has  <em>“<strong>File1.csv</strong>” “<strong>File2.txt</strong>” “<strong>Logo.ico</strong>” <em>and a directory  named</em>  “<strong>Bin</strong>”</em> which has 3 more files inside.""</p>
<pre><code> CL-In2batch.dll "File1.csv;Logo.ico;Bin" /notify | Clip
</code></pre>
<blockquote>
<p>The above command generates batch code for <strong>File1.csv</strong> ,<strong>File2.txt</strong> , <strong>Logo.ico</strong> and <strong>all the 3 files</strong> present in the directory <strong>Bin</strong>. After each file operation a notification is triggered at the bottom right corner of our screen. The generated code is directly piped to our clipboard after the operation is complete.</p>
</blockquote>
<pre><code>CL-In2batch.dll "E:\Batchscripts\Bin" &gt;&gt;MybatchScript.bat
</code></pre>
<blockquote>
<p>The above command generates the batch code to embed all the files present in the folder  <strong>E:\Batchscripts\Bin</strong>  and redirect the code to a file called <strong>MybatchScript.bat</strong></p>
</blockquote>
<h3 id="todo-list-some-based-on-private-requests-">TODO List (Some based on private requests) :</h3>
<ul>
<li class="task-list-item">
<p><input type="checkbox" class="task-list-item-checkbox" checked="true" disabled="">  Make a parameter to enable a user to customize the batch output function name, If an argument is not parsed, generate a unique random number instead.</p>
</li>
<li class="task-list-item">
<p><input type="checkbox" class="task-list-item-checkbox" checked="true" disabled="">  Write a notification function so the user can know after a batch operation is complete (Add as an optional param)</p>
</li>
<li class="task-list-item">
<p><input type="checkbox" class="task-list-item-checkbox" checked="true" disabled="">  Make it possible to embed folders.</p>
</li>
<li class="task-list-item">
<p><input type="checkbox" class="task-list-item-checkbox" checked="true" disabled=""> Fix the high CPU/RAM usage.</p>
</li>
<li class="task-list-item">
<p><input type="checkbox" class="task-list-item-checkbox" checked="true" disabled="">  Add blocks (Start/End Regions) in generated code to show the user<br>
where code starts and ends</p>
<pre class=" language-batch"><code class="prism  language-batch"><span class="token comment">rem ========== Start Region In2Batch CL-Generator ========</span>
<span class="token comment">rem ========== End Region In2Batch CL-Generator ========== </span>
</code></pre>
</li>
<li class="task-list-item">
<p><input type="checkbox" class="task-list-item-checkbox" checked="true" disabled="">   Detect file sizes before starting operation. 0 byte files to be skipped automatically without breaking.</p>
<pre class=" language-batch"><code class="prism  language-batch"><span class="token comment">rem Assuming that Readme.txt is 0 bytes,this is how it'll be handled;</span>
<span class="token comment">:: File Readme.txt contains no readable data. Size:0 bytes </span>

</code></pre>
</li>
<li class="task-list-item">
<p><input type="checkbox" class="task-list-item-checkbox" checked="true" disabled="">   Fix the code output to make it more aligned to fold-able  code blocks that can be folded in various IDEs like Sublimetext editor/Notepad++ etc</p>
</li>
<li class="task-list-item">
<p><input type="checkbox" class="task-list-item-checkbox" disabled="">  Make it possible for a user to use wildcards while working on folders.</p>
<pre class=" language-batch"><code class="prism  language-batch"><span class="token comment">rem Example:</span>
<span class="token command"><span class="token keyword">CL</span>-In2batch.dll <span class="token string">"%cd%\bin\*.bat"</span> | Clip </span>

</code></pre>
</li>
<li class="task-list-item">
<p><input type="checkbox" class="task-list-item-checkbox" checked="true" disabled="">   Write function to terminate ongoing operations by pressing the esc/end button.</p>
</li>
<li class="task-list-item">
<p><input type="checkbox" class="task-list-item-checkbox" checked="true" disabled="">   Make it more CPU friendly. less cpu usage / less memory use.</p>
</li>
<li class="task-list-item">
<p><input type="checkbox" class="task-list-item-checkbox" disabled=""> Reformat the code output to fix Certutil error when decoding huge files. (Mostly files that are GEQ 200kb)</p>
</li>
</ul>
<h3 id="exit-codes-parsed-to-dos-system-variable--errorlevel">Exit codes parsed to DOS system variable : %errorlevel%</h3>
<pre><code> (0) - Success / No Error.
 (1) - One or more files may have failed ,may be caused by :
     - Non existant Filename parsed.
     - Invalid path.
     - File is not opened in read mode or other error.
 (3) - CertUtil error.

</code></pre>
<p><strong>For more batch scripting plugins visit:</strong> <a href="http://www.thebateam.org">www.thebateam.org</a></p>

