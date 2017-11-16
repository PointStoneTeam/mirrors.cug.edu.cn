<!DOCTYPE html>
<html lang="zh">
<head>
<meta charset="UTF-8">
<title>中国地质大学开源镜像站</title>
<!--link href="http://fonts.lug.ustc.edu.cn/css?family=Lato:100,300,400,700" media="all" rel="stylesheet" type="text/css"-->
<link href="stylesheets/bootstrap.min.css" media="all" rel="stylesheet" type="text/css">
<link href="stylesheets/pygments.css" media="all" rel="stylesheet" type="text/css">
<link href="stylesheets/style.css" media="all" rel="stylesheet" type="text/css">
<link href="stylesheets/datatables.css" media="all" rel="stylesheet" type="text/css">
  <style>
    .fluid-width-video-wrapper{width:100%;position:relative;padding:0;}.fluid-width-video-wrapper iframe,.fluid-width-video-wrapper object,.fluid-width-video-wrapper embed {position:absolute;top:0;left:0;width:100%;height:100%;}
  </style>
<!--[if IE 6]>
	<script src="//letskillie6.googlecode.com/svn/trunk/2/zh_CN.js"></script>
<![endif]-->
<!--[if IE 7]>
	<script src="//letskillie6.googlecode.com/svn/trunk/2/zh_CN.js"></script>
<![endif]-->
<script src="javascripts/jquery-1.10.2.min.js" type="text/javascript"></script>
<script src="javascripts/bootstrap.min.js" type="text/javascript"></script>
<style type="text/css">
#dataTable1 tr:hover {
    background-color: #d9edf7;
    cursor:pointer;
}
#dataTable1 tr:hover td {background:none;}
@media screen and (max-width: 480px) {
.title {
	font-size: 25px;
}
}

.myadd {
  font-size: 13px;
}

.myadd a{
  font-size: 13px;
}
</style>
<script src="javascripts/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="javascripts/main.js" type="text/javascript"></script>
<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport">
</head>
<body class="page-header-fixed bg-1" style="padding-top: 5px;">
<div class="modal-shiftfix">
  <!-- Navigation -->
  <!-- End Navigation -->
  <div class="container-fluid main-content">

    <!-- DataTables Example -->
    <div class="row">
      <div class="col-lg-12">
        <div class="widget-container fluid-height clearfix">
          <div class="heading">
            <div class="page-title" style="padding: 0px;">
              <h1 class="title">
              <span id="titlespan"><a href="/">中国地质大学开源镜像站</a></span> <!--span id="Changelanguage" style="font-size: 15px;"><a href="javascript:void(0)">English Version</a></span-->

                    <!--div class="row">
                    <div class="col-lg-11">
                    <span id="titlespan"><a href="/">中国地质大学开源镜像站</a></span>
                    </div>
                    <div class="col-lg-1">
                    <span id="Changelanguage" style="font-size: 15px;"><a href="javascript:void(0)">English Version</a></span>
                    </div>
                    </div-->
               </h1>
            </div>
            <i class="fa fa-table"></i> </div>
          <div class="widget-content padded clearfix">
            <table class="table table-bordered table-striped" id="dataTable1">
              <thead>
              <th id="nameth"> 名称 </th>
                <th class="hidden-xs" id="sizeth"> 大小 </th>
                <th class="hidden-xs" id="upstreamth"> 上游 </th>
                <th class="hidden-xs" id="starttimeth"> 同步开始时间 </th>
                <th class="hidden-xs" id="endtimeth"> 同步结束时间 </th>
                <th id="statusth"> 状态 </th>
                <!--th> 使用帮助 </th-->
                  </thead>
              <tbody>
<?php

//镜像名|大小|上游|开始时间|结束时间|同步状态

    function formatSizeUnits($bytes)
    {
        if ($bytes >= 1099511627776)
        {
            $bytes = number_format($bytes / 1099511627776, 2) . ' TB';
        }
        elseif ($bytes >= 1073741824)
        {
            $bytes = number_format($bytes / 1073741824, 2) . ' GB';
        }
        elseif ($bytes >= 1048576)
        {
            $bytes = number_format($bytes / 1048576, 2) . ' MB';
        }
        elseif ($bytes >= 1024)
        {
            $bytes = number_format($bytes / 1024, 2) . ' KB';
        }
        elseif ($bytes > 1)
        {
            $bytes = $bytes . ' bytes';
        }
        elseif ($bytes == 1)
        {
            $bytes = $bytes . ' byte';
        }
        else
        {
            $bytes = '0 bytes';
        }

        return $bytes;
    }

function formatFileSize($fileSize)
{
    $unit = array(' Bytes', ' KB', ' MB', ' GB', ' TB', ' PB', ' EB', ' ZB', ' YB');
    $i = 0;

    /*
    while($fileSize >= 1024 && $i < 8)
    {
        $fileSize /= 1024;
        ++$i;
    }
    */

    /*
    以上代码还可以优化一下
    由于计算机做乘法比做除法快
    */
    $inv = 1 / 1024;

    while($fileSize >= 1024 && $i < 8)
    {
        $fileSize *= $inv;
        ++$i;
    }

    //return sprintf("%.2f", $fileSize) . $unit[$i];

    // 改正上一条结果为整数，输出却带两个无意义0的小数位的浮点数
    $fileSizeTmp = sprintf("%.2f", $fileSize);

    // 以下代码在99.99%的情况下结果会是正确的，除非你使用了"超超大数"。：）
    return ($fileSizeTmp - (int)$fileSizeTmp ? $fileSizeTmp : $fileSize) . $unit[$i];
}

$file = fopen("/home/sync/var/stat","r");
if ($file)
{
$allsize = 0;
while(! feof($file))
  {
	$str = fgets($file);
	if ($str != '')
	{
		//echo fgets($file). "<br />";
		$status = explode('|', $str);
		$name = $status[0];
		$size = $status[1];
		$upstream = $status[2];
		$starttime = $status[3];
		$endtime = $status[4];
		$syncstatus = $status[5];
		$allsize += $size;
		$syncstatus = str_replace(PHP_EOL, '', $syncstatus);
		$syncstatus = trim($syncstatus);
		//echo $syncstatus;
		//$size = formatFileSize($size);
		$size = formatSizeUnits($size);
        if ($syncstatus == "finished")
		{
			$statusstr = "<span class=\"label label-success\">同步完成</span>";
		}
		else if ($syncstatus == "error")
		{
			$statusstr = '<span class="label label-danger">同步失败</span>';
		}
		else if ($syncstatus == 'syncing')
		{
			$statusstr = '<span class="label label-warning">正在同步</span>';
		}
echo <<<EOF
<tr>
	<td><a href="http://mirrors.cug.edu.cn/$name/" target="_blank">$name</a></td>
	<td class="hidden-xs">$size</td>
	<td class="hidden-xs">$upstream</td>
	<td class="hidden-xs">$starttime</td>
	<td class="hidden-xs">$endtime</td>
	<td>$statusstr</td>
	<!--td class="actions"><a href="help.html" target="_blank">使用帮助</a></td-->
</tr>
EOF;
	}

  }
$allsize = formatFileSize($allsize);
echo <<<EOF
<!--$allsize-->
EOF;
fclose($file);
}

?>
              </tbody>
            </table>
          </div>
            <div class="row page-title">
              <div class="col-lg-12">
                <div class="myadd">
                  <a href="help.html" target="_blank">关于本站 </a><a href="repogen/" target="_blank"> 配置生成 </a><a href="history.html" target="_blank"> 镜像历史 </a><a href="https://www.pointstone.org" target="_blank"> 点石团队</a>
                </div>
              </div>
            </div>
            <div class="row page-title" style="padding-bottom: 10px;">
              <div class="col-lg-12">
                  <div class="myadd">本镜像站由中国地质大学点石团队维护。</div>
              </div>
            </div>
        </div>
      </div>
    </div>
    <!-- end DataTables Example -->
  </div>
</div>

<script>
  // (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  // (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  // m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  // })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  // ga('create', 'UA-59628863-6', 'auto');
  // ga('send', 'pageview');

</script>

<script>

/*
$("#Changelanguage").click(function(){
    if ($("#Changelanguage").text() == "English Version")
    {
        $("#Changelanguage a").text("中文版");
        $("#titlespan").text("China University of Geosciences Source Mirrors Site");
        //$("#titlespan").css("font-size", "20px");
        $("#nameth").text("name");
        $("#sizeth").text("size");
        $("#upstreamth").text("upstream");
        $("#starttimeth").text("start time");
        $("#endtimeth").text("end time");
        $("#statusth").text("status");
        $(".label-success").text("Synchronized");
        $(".label-warning").text("Synchronizing");
        $(".label-danger").text("Failed");
    }
    else
    {
        $("#Changelanguage a").text("English Version");
        $("#titlespan").text("中国地质大学开源镜像站");
        //$("#titlespan").css("font-size", "36px");
        $("#nameth").text(" 名称 ");
        $("#sizeth").text(" 大小 ");
        $("#upstreamth").text(" 上游 ");
        $("#starttimeth").text(" 同步开始时间 ");
        $("#endtimeth").text(" 同步结束时间 ");
        $("#statusth").text(" 状态 ");
        $(".label-success").text("同步完成");
        $(".label-warning").text("正在同步");
        $(".label-danger").text("同步失败");
    }
});
*/
</script>
</body>
</html>
