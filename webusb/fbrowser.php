<?php  

if($_GET['action'] == "logout"){  
    unset($_SESSION['userid']);  
    unset($_SESSION['username']);  
    echo 'You have been logout. <a href="login.html">Login again..</a>';  
    exit;  
}
  
//..  
if(!isset($_POST['submit'])){  
   exit('Please visit our <a href="login.html">home page</a>!');  
}

$username = htmlspecialchars($_POST['username']);  
$password = MD5($_POST['password']);  

//echo '<p>',$username,'</p>';
//echo '<p>',$password,'</p>'; 

$pwdPre = "4124bc0a9335c27f086f24ba207a4912";
$namePre = "zhoujj";

if($password === $pwdPre && $username === $namePre){
	session_start();
	$_SESSION['username'] = $username;
	$_SESSION['userid'] = $username;
	echo '<h2>Hi, ',$username,'</h2>';
	echo '<hr>';
	echo '<ul>';
	$c = 'ls ./'.$pwdPre.'/ | while read line; do echo "<li><a href=\"./'.$pwdPre.'/$line\">$line</a></li>";done;';
	//$c = 'ls ./'.$pwdPre.'/ | while read line; do echo "<li><a href=dl.php?id='.$pwdPre.'&name=$line>$line</a></li>";done;';
	//echo $c;
	system($c, $retval);
	echo '</ul>';
	echo '<hr>';
	echo 'Please remember to <a href="fbrowser.php?action=logout">LOGOUT</a>';
	exit;
}else{
	exit('Username or password error, please login again. <a href="javascript:history.back(-1);">Retry...</a>');	
}

//.........  
#include('conn.php');  
//$check_query = mysql_query("select userid from user_list where username='$username' and password='$password' limit 1");  
//if($result = mysql_fetch_array($check_query)){  
//    //....  
//    session_start();  
//    $_SESSION['username'] = $username;  
//    $_SESSION['userid'] = $result['userid'];  
//    echo $username,' ...... <a href="my.php">....</a><br />';  
//    echo '.... <a href="login.php?action=logout">..</a> ...<br />';  
//    exit;  
//} else {  
//    exit('......... <a href="javascript:history.back(-1);">..</a> ..');  
//}  
  
?>
