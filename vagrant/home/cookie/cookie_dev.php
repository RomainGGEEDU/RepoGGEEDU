<?php
// Détection du device : http://mobiledetect.net/
  // - computer
  // - tablet
  // - phone

require_once 'Mobile-Detect/Mobile_Detect.php';
$detect = new Mobile_Detect;
$deviceType = ($detect->isMobile() ? ($detect->isTablet() ? 'tablet' : 'phone') : 'computer');
$scriptVersion = $detect->getScriptVersion();
$agent = $deviceType;
?>

<script>

function setCookie(cname,cvalue,exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires=" + d.toGMTString();
    document.cookie = cname+"="+cvalue+"; "+expires+'; path=/;';
}

function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1);
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}

function checkCookie() {
    var Device=getCookie("mobile_detect");
    if (Device != "") {
    } else {
       Device = "<?php print $agent; ?>";
       if (Device != "" && Device != null) {
           setCookie("mobile_detect", Device, 30);
       }
    }
    var CurrentUrl=getCookie("first_page");
    if (CurrentUrl != "") {
    } else {
       CurrentUrl = window.location;
       if (CurrentUrl != "" && CurrentUrl != null) {
           setCookie("first_page", CurrentUrl, 30);
       }
    }
    alert("First_page = " + CurrentUrl);
}

</script>
