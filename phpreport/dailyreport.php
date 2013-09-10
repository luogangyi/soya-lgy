<?php
include_once("connect.php");

require_once 'Classes/PHPExcel.php';
require_once 'Classes/PHPExcel/Writer/Excel5.php';

$tquery = mysql_query("select * from site_infos where site_infos.key = 'NAME'");

$trow = mysql_fetch_array($tquery);

$sitename=$trow['value'];


if(isset($_GET["label_id"])){

	$type=$_GET["type"];
	$d1=$_GET["d1"];
	$d2=$_GET["d2"];
	
	$tquery = mysql_query("select * from site_infos where site_infos.key = 'NAME'");
	
	$trow = mysql_fetch_array($tquery);
	
	$sitename=$trow['value'];

	$objPHPExcel = new PHPExcel();  
	$objPHPExcel = PHPExcel_IOFactory::load("weibo.xls");
	$objPHPExcel->setActiveSheetIndex(0);
	
	header("Content-Type: application/vnd.ms-excel; charset=UTF-8");
	header('Content-Disposition: attachment;filename="Label - Daily Report Brief '.date("Y-m-d").'.xls"');
	header('Cache-Control: max-age=0');

	$wherestr= " and created_at > '".date("Y-m-d G:i:s",$d1/1000)."' and created_at < '".date("Y-m-d G:i:s",$d2/1000)."' ";
		
	$label_id = $_GET["label_id"];
	$query=mysql_query("select a1.id as info_id, a1.created_at, a1.urgency, b1.* from weibo_statuses a1,analysis_categorizeds b1, operations c1 where c1.operatable_id = a1.id and c1.operatable_type='WeiboStatus' and c1.handled=1 and c1.ignored=0 and a1.id = b1.analysable_id and b1.analysable_type='WeiboStatus' and b1.label_id = '".$label_id."'".$wherestr 
						."union all select a2.id as info_id, a2.created_at, a2.urgency, b2.* from wiki_posts a2,analysis_categorizeds b2, operations c2 where c2.operatable_id = a2.id and c2.operatable_type='WikiPost' and c2.handled=1 and c2.ignored=0 and a2.id = b2.analysable_id and b2.analysable_type='WikiPost' and b2.label_id = '".$label_id."'". $wherestr 
						."union all select a3.id as info_id, a3.created_at, a3.urgency, b3.* from bbs_posts a3,analysis_categorizeds b3, operations c3 where c3.operatable_id = a3.id and c3.operatable_type='BbsPost' and c3.handled=1 and c3.ignored=0 and a3.id = b3.analysable_id and b3.analysable_type='BbsPost' and b3.label_id =  '".$label_id."'". $wherestr 
						."union all select a4.id as info_id, a4.created_at, a4.urgency, b4.* from blog_posts a4,analysis_categorizeds b4 , operations c4 where c4.operatable_id = a4.id and c4.operatable_type='BlogPost' and c4.handled=1 and c4.ignored=0 and a4.id = b4.analysable_id and b4.analysable_type='BlogPost' and b4.label_id =  '".$label_id."'". $wherestr 
						."union all select a5.id as info_id, a5.created_at, a5.urgency, b5.* from video_posts a5,analysis_categorizeds b5 , operations c5 where c5.operatable_id = a5.id and c5.operatable_type='VideoPost' and c5.handled=1 and c5.ignored=0 and a5.id = b5.analysable_id and b5.analysable_type='VideoPost' and b5.label_id =  '".$label_id."'". $wherestr 
						."union all select a6.id as info_id, a6.created_at, a6.urgency, b6.* from news a6,analysis_categorizeds b6 , operations c6 where c6.operatable_id = a6.id and c6.operatable_type='News' and c6.handled=1 and c6.ignored=0 and a6.id = b6.analysable_id and b6.analysable_type='News' and b6.label_id =  '".$label_id."'". $wherestr);
	
	// echo "select a1.id as info_id, a1.created_at, a1.urgency, b1.* from weibo_statuses a1,analysis_categorizeds b1 where a1.id = b1.analysable_id and b1.analysable_type='WeiboStatus' and b1.label_id = '".$label_id."'".$wherestr 
	// 					."union all select a2.id as info_id, a2.created_at, a2.urgency, b2.* from wiki_posts a2,analysis_categorizeds b2  where a2.id = b2.analysable_id and b2.analysable_type='WikiPost' and b2.label_id = '".$label_id."'". $wherestr 
	// 					."union all select a3.id as info_id, a3.created_at, a3.urgency, b3.* from bbs_posts a3,analysis_categorizeds b3 where a3.id = b3.analysable_id and b3.analysable_type='WikiPost' and b3.label_id =  '".$label_id."'". $wherestr 
	// 					."union all select a4.id as info_id, a4.created_at, a4.urgency, b4.* from blog_posts a4,analysis_categorizeds b4 where a4.id = b4.analysable_id and b4.analysable_type='WikiPost' and b4.label_id =  '".$label_id."'". $wherestr 
	// 					."union all select a5.id as info_id, a5.created_at, a5.urgency, b5.* from video_posts a5,analysis_categorizeds b5 where a5.id = b5.analysable_id and b5.analysable_type='WikiPost' and b5.label_id =  '".$label_id."'". $wherestr 
	// 					."union all select a6.id as info_id, a6.created_at, a6.urgency, b6.* from news a6,analysis_categorizeds b6 where a6.id = b6.analysable_id and b6.analysable_type='WikiPost' and b6.label_id =  '".$label_id."'". $wherestr;
	$i=1;


	while($row = mysql_fetch_array($query)) {
		$i++;
		//echo $i;

		$sub_sub_query = mysql_query("SELECT `labels`.* FROM `labels` INNER JOIN `analysis_categorizeds` ON `analysis_categorizeds`.`label_id` = `labels`.`id` WHERE `analysis_categorizeds`.`analysable_id` = "+$row['id']+" AND `analysis_categorizeds`.`analysable_type` = '"+$row["analysable_type"]+"' AND `labels`.`category_id` = 2");
		$product_label = "";
		while ($temp = mysql_fetch_array($sub_sub_query)) {
			$product_label=$product_label.$temp["str"]." ";
		}

		$sub_sub_query2 = mysql_query("SELECT `labels`.* FROM `labels` INNER JOIN `analysis_categorizeds` ON `analysis_categorizeds`.`label_id` = `labels`.`id` WHERE `analysis_categorizeds`.`analysable_id` = "+$row['id']+" AND `analysis_categorizeds`.`analysable_type` = '"+$row["analysable_type"]+"' AND `labels`.`category_id` = 3");
		$info_label = "";
		while ($temp = mysql_fetch_array($sub_sub_query2)) {
			$info_label=$info_label.$temp["str"]." ";
		}

		if($row["analysable_type"] == "WeiboStatus"){
			
			$sub_query=mysql_query("select a.*, b.str from weibo_statuses a, info_sources b where a.info_source_id=b.id and a.id=".$row['info_id']);
			

			//echo "select a.*, b.str from weibo_statuses a, info_sources b where a.info_source_id=b.id and a.id=".$row['info_id'];
			
		    $sub_row = mysql_fetch_array($sub_query);

		    $urgency =""
		    if($sub_row['sentiment']==1){
				$tonality = "正面";
			}else if($sub_row['sentiment']==2){
				$tonality = "负面";
				if ($sub_row['urgency']<=1) {
					$urgency ="一般级";
				}else if ($sub_row['urgency']==2) {
					$urgency ="关注级";
				}else if ($sub_row['urgency']==3) {
					$urgency ="干预级";
				}else if ($sub_row['urgency']==4) {
					$urgency ="危机级";
				}else if ($sub_row['urgency']==5) {
					$urgency ="重大危机级";
				}
			}else{
				$tonality = "中性";
			}

			$objPHPExcel->getActiveSheet()->setCellValue("A".$i,strval($i-1));  		
			$objPHPExcel->getActiveSheet()->setCellValue("B".$i,$sitename);		
			$objPHPExcel->getActiveSheet()->setCellValue("C".$i,$product_label);		
			$objPHPExcel->getActiveSheet()->setCellValue("D".$i,$info_label);
		    $objPHPExcel->getActiveSheet()->setCellValue("E".$i,$tonality);
		    $objPHPExcel->getActiveSheet()->setCellValue("F".$i,$urgency);  
		    $objPHPExcel->getActiveSheet()->setCellValue("G".$i,$row["analysable_type"]);
		    $objPHPExcel->getActiveSheet()->setCellValue("H".$i,$sub_row['str']); 
		    $objPHPExcel->getActiveSheet()->setCellValue("I".$i,$sub_row['weibo_user_screen_name']);
		    $objPHPExcel->getActiveSheet()->setCellValue("J".$i,$sub_row['follower_count']);
		    $objPHPExcel->getActiveSheet()->setCellValue("K".$i,$sub_row['text']);
		    $objPHPExcel->getActiveSheet()->setCellValue("L".$i,$sub_row['repost_count']);
		    $objPHPExcel->getActiveSheet()->setCellValue("M".$i,$sub_row['comment_count']);
		    $objPHPExcel->getActiveSheet()->setCellValue("N".$i,$sub_row['url']);
		    $objPHPExcel->getActiveSheet()->setCellValue("O".$i,$sub_row['geo_info_province']."-".$sub_row['geo_info_city']);
		    $objPHPExcel->getActiveSheet()->setCellValue("P".$i,$sub_row['created_at']);

		    //echo $sitename." ".$sub_row['url'];
		}

	   else if($row["analysable_type"] == "News"){

	   		$sub_query=mysql_query("select a.*, b.str from news a, info_sources b where a.info_source_id=b.id and a.id=".$row['info_id']);
			//echo "select b.str from weibo_statuses a, info_sources b where a.info_source_id=b.id and a.id=".$row['id'];
			
		    $sub_row = mysql_fetch_array($sub_query);

		    $urgency =""
		    if($sub_row['sentiment']==1){
				$tonality = "正面";
			}else if($sub_row['sentiment']==2){
				$tonality = "负面";
				if ($sub_row['urgency']<=1) {
					$urgency ="一般级";
				}else if ($sub_row['urgency']==2) {
					$urgency ="关注级";
				}else if ($sub_row['urgency']==3) {
					$urgency ="干预级";
				}else if ($sub_row['urgency']==4) {
					$urgency ="危机级";
				}else if ($sub_row['urgency']==5) {
					$urgency ="重大危机级";
				}
			}else{
				$tonality = "中性";
			}

			$objPHPExcel->getActiveSheet()->setCellValue("A".$i,strval($i-1));  		
			$objPHPExcel->getActiveSheet()->setCellValue("B".$i,$sitename);		
			$objPHPExcel->getActiveSheet()->setCellValue("C".$i,$product_label);		
			$objPHPExcel->getActiveSheet()->setCellValue("D".$i,$info_label);
		    $objPHPExcel->getActiveSheet()->setCellValue("E".$i,$tonality);
		    $objPHPExcel->getActiveSheet()->setCellValue("F".$i,$urgency);  
		    $objPHPExcel->getActiveSheet()->setCellValue("G".$i,$row["analysable_type"]);
		    $objPHPExcel->getActiveSheet()->setCellValue("H".$i,$sub_row['str']); 
		    $objPHPExcel->getActiveSheet()->setCellValue("I".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("J".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("K".$i,$sub_row['title']);
		    $objPHPExcel->getActiveSheet()->setCellValue("L".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("M".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("N".$i,$sub_row['url']);
		    $objPHPExcel->getActiveSheet()->setCellValue("O".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("P".$i,$sub_row['created_at']);


		    //echo $sitename." ".$sub_row['url'];

	   }else if($row["analysable_type"] == "BbsPost"){

	   		$sub_query=mysql_query("select a.*, b.str from bbs_posts a, info_sources b where a.info_source_id=b.id and a.id=".$row['info_id']);
			//echo "select b.str from weibo_statuses a, info_sources b where a.info_source_id=b.id and a.id=".$row['id'];
			
		    $sub_row = mysql_fetch_array($sub_query);
		    
	    	$urgency =""
		    if($sub_row['sentiment']==1){
				$tonality = "正面";
			}else if($sub_row['sentiment']==2){
				$tonality = "负面";
				if ($sub_row['urgency']<=1) {
					$urgency ="一般级";
				}else if ($sub_row['urgency']==2) {
					$urgency ="关注级";
				}else if ($sub_row['urgency']==3) {
					$urgency ="干预级";
				}else if ($sub_row['urgency']==4) {
					$urgency ="危机级";
				}else if ($sub_row['urgency']==5) {
					$urgency ="重大危机级";
				}
			}else{
				$tonality = "中性";
			}

			$objPHPExcel->getActiveSheet()->setCellValue("A".$i,strval($i-1));  		
			$objPHPExcel->getActiveSheet()->setCellValue("B".$i,$sitename);		
			$objPHPExcel->getActiveSheet()->setCellValue("C".$i,$product_label);		
			$objPHPExcel->getActiveSheet()->setCellValue("D".$i,$info_label);
		    $objPHPExcel->getActiveSheet()->setCellValue("E".$i,$tonality);
		    $objPHPExcel->getActiveSheet()->setCellValue("F".$i,$urgency);  
		    $objPHPExcel->getActiveSheet()->setCellValue("G".$i,$row["analysable_type"]);
		    $objPHPExcel->getActiveSheet()->setCellValue("H".$i,$sub_row['str']); 
		    $objPHPExcel->getActiveSheet()->setCellValue("I".$i,$sub_row['bbs_user_screen_name']);
		    $objPHPExcel->getActiveSheet()->setCellValue("J".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("K".$i,$sub_row['title']);
		    $objPHPExcel->getActiveSheet()->setCellValue("L".$i,$sub_row['read_count']);
		    $objPHPExcel->getActiveSheet()->setCellValue("M".$i,$sub_row['comment_count']);
		    $objPHPExcel->getActiveSheet()->setCellValue("N".$i,$sub_row['url']);
		    $objPHPExcel->getActiveSheet()->setCellValue("O".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("P".$i,$sub_row['created_at']);


		    //echo $sitename." ".$sub_row['url'];
	   }else if($row["analysable_type"] == "BlogPost"){
	   		$sub_query=mysql_query("select a.*, b.str from blog_posts a, info_sources b where a.info_source_id=b.id and a.id=".$row['info_id']);
			//echo "select b.str from weibo_statuses a, info_sources b where a.info_source_id=b.id and a.id=".$row['id'];
			
		    $sub_row = mysql_fetch_array($sub_query);
		    
		   	$urgency =""
		    if($sub_row['sentiment']==1){
				$tonality = "正面";
			}else if($sub_row['sentiment']==2){
				$tonality = "负面";
				if ($sub_row['urgency']<=1) {
					$urgency ="一般级";
				}else if ($sub_row['urgency']==2) {
					$urgency ="关注级";
				}else if ($sub_row['urgency']==3) {
					$urgency ="干预级";
				}else if ($sub_row['urgency']==4) {
					$urgency ="危机级";
				}else if ($sub_row['urgency']==5) {
					$urgency ="重大危机级";
				}
			}else{
				$tonality = "中性";
			}

			$objPHPExcel->getActiveSheet()->setCellValue("A".$i,strval($i-1));  		
			$objPHPExcel->getActiveSheet()->setCellValue("B".$i,$sitename);		
			$objPHPExcel->getActiveSheet()->setCellValue("C".$i,$product_label);		
			$objPHPExcel->getActiveSheet()->setCellValue("D".$i,$info_label);
		    $objPHPExcel->getActiveSheet()->setCellValue("E".$i,$tonality);
		    $objPHPExcel->getActiveSheet()->setCellValue("F".$i,$urgency);  
		    $objPHPExcel->getActiveSheet()->setCellValue("G".$i,$row["analysable_type"]);
		    $objPHPExcel->getActiveSheet()->setCellValue("H".$i,$sub_row['str']); 
		    $objPHPExcel->getActiveSheet()->setCellValue("I".$i,$sub_row['blog_user_screen_name']);
		    $objPHPExcel->getActiveSheet()->setCellValue("J".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("K".$i,$sub_row['title']);
		    $objPHPExcel->getActiveSheet()->setCellValue("L".$i,$sub_row['read_count']);
		    $objPHPExcel->getActiveSheet()->setCellValue("M".$i,$sub_row['comment_count']);
		    $objPHPExcel->getActiveSheet()->setCellValue("N".$i,$sub_row['url']);
		    $objPHPExcel->getActiveSheet()->setCellValue("O".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("P".$i,$sub_row['created_at']);


	   }else if($row["analysable_type"] == "WikiPost"){

	   		$sub_query=mysql_query("select a.*, b.str from wiki_posts a, info_sources b where a.info_source_id=b.id and a.id=".$row['info_id']);
			//echo "select b.str from weibo_statuses a, info_sources b where a.info_source_id=b.id and a.id=".$row['id'];
			
		    $sub_row = mysql_fetch_array($sub_query);
		    
		   		   	$urgency =""
		    if($sub_row['sentiment']==1){
				$tonality = "正面";
			}else if($sub_row['sentiment']==2){
				$tonality = "负面";
				if ($sub_row['urgency']<=1) {
					$urgency ="一般级";
				}else if ($sub_row['urgency']==2) {
					$urgency ="关注级";
				}else if ($sub_row['urgency']==3) {
					$urgency ="干预级";
				}else if ($sub_row['urgency']==4) {
					$urgency ="危机级";
				}else if ($sub_row['urgency']==5) {
					$urgency ="重大危机级";
				}
			}else{
				$tonality = "中性";
			}

			$objPHPExcel->getActiveSheet()->setCellValue("A".$i,strval($i-1));  		
			$objPHPExcel->getActiveSheet()->setCellValue("B".$i,$sitename);		
			$objPHPExcel->getActiveSheet()->setCellValue("C".$i,$product_label);		
			$objPHPExcel->getActiveSheet()->setCellValue("D".$i,$info_label);
		    $objPHPExcel->getActiveSheet()->setCellValue("E".$i,$tonality);
		    $objPHPExcel->getActiveSheet()->setCellValue("F".$i,$urgency);  
		    $objPHPExcel->getActiveSheet()->setCellValue("G".$i,$row["analysable_type"]);
		    $objPHPExcel->getActiveSheet()->setCellValue("H".$i,$sub_row['str']); 
		    $objPHPExcel->getActiveSheet()->setCellValue("I".$i,$sub_row['wiki_user_screen_name']);
		    $objPHPExcel->getActiveSheet()->setCellValue("J".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("K".$i,$sub_row['title']);
		    $objPHPExcel->getActiveSheet()->setCellValue("L".$i,$sub_row['read_count']);
		    $objPHPExcel->getActiveSheet()->setCellValue("M".$i,$sub_row['comment_count']);
		    $objPHPExcel->getActiveSheet()->setCellValue("N".$i,$sub_row['url']);
		    $objPHPExcel->getActiveSheet()->setCellValue("O".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("P".$i,$sub_row['created_at']);




	   }else if($row["analysable_type"] == "VideoPost"){

	   		$sub_query=mysql_query("select a.*, b.str from video_posts a, info_sources b where a.info_source_id=b.id and a.id=".$row['info_id']);
			//echo "select b.str from weibo_statuses a, info_sources b where a.info_source_id=b.id and a.id=".$row['id'];
			
		    $sub_row = mysql_fetch_array($sub_query);
		    
		    $urgency =""
		    if($sub_row['sentiment']==1){
				$tonality = "正面";
			}else if($sub_row['sentiment']==2){
				$tonality = "负面";
				if ($sub_row['urgency']<=1) {
					$urgency ="一般级";
				}else if ($sub_row['urgency']==2) {
					$urgency ="关注级";
				}else if ($sub_row['urgency']==3) {
					$urgency ="干预级";
				}else if ($sub_row['urgency']==4) {
					$urgency ="危机级";
				}else if ($sub_row['urgency']==5) {
					$urgency ="重大危机级";
				}
			}else{
				$tonality = "中性";
			}

			$objPHPExcel->getActiveSheet()->setCellValue("A".$i,strval($i-1));  		
			$objPHPExcel->getActiveSheet()->setCellValue("B".$i,$sitename);		
			$objPHPExcel->getActiveSheet()->setCellValue("C".$i,$product_label);		
			$objPHPExcel->getActiveSheet()->setCellValue("D".$i,$info_label);
		    $objPHPExcel->getActiveSheet()->setCellValue("E".$i,$tonality);
		    $objPHPExcel->getActiveSheet()->setCellValue("F".$i,$urgency);  
		    $objPHPExcel->getActiveSheet()->setCellValue("G".$i,$row["analysable_type"]);
		    $objPHPExcel->getActiveSheet()->setCellValue("H".$i,$sub_row['str']); 
		    $objPHPExcel->getActiveSheet()->setCellValue("I".$i,$sub_row['video_user_screen_name']);
		    $objPHPExcel->getActiveSheet()->setCellValue("J".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("K".$i,$sub_row['title']);
		    $objPHPExcel->getActiveSheet()->setCellValue("L".$i,$sub_row['watch_count']);
		    $objPHPExcel->getActiveSheet()->setCellValue("M".$i,$sub_row['comment_count']);
		    $objPHPExcel->getActiveSheet()->setCellValue("N".$i,$sub_row['url']);
		    $objPHPExcel->getActiveSheet()->setCellValue("O".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("P".$i,$sub_row['created_at']);


	   }



	}

mysql_close($link);

$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel5');
$objWriter->save('php://output');
exit;

}

if(isset($_GET["type"])&&!isset($_GET["label_id"])){

	$type=$_GET["type"];
	$d1=$_GET["d1"];
	$d2=$_GET["d2"];
	

	
	if($type=="weibo"){
		$objPHPExcel = new PHPExcel();  
		$objPHPExcel = PHPExcel_IOFactory::load("weibo.xls");
		$objPHPExcel->setActiveSheetIndex(0);
		
		header("Content-Type: application/vnd.ms-excel; charset=UTF-8");
		header('Content-Disposition: attachment;filename="WEIBO - Daily Report Brief '.date("Y-m-d").'.xls"');
		header('Cache-Control: max-age=0');
			
		
		$query=mysql_query("SELECT a.*,b.follower_count FROM weibo_statuses a,weibo_users b,operations c WHERE a.created_at BETWEEN '". date("Y-m-d G:i:s",$d1/1000)."' AND '". date("Y-m-d G:i:s",$d2/1000)."' and c.handled=1 and c.ignored=0 and b.id=a.weibo_user_id and c.operatable_id = a.id and c.operatable_type ='WeiboStatus' ORDER BY created_at DESC");
		$i=1;
		while($row = mysql_fetch_array($query)) {
			$i++;
			$sub_query=mysql_query("select b.str from weibo_statuses a, info_sources b where a.info_source_id=b.id and a.id=".$row['id']);
			//echo "select b.str from weibo_statuses a, info_sources b where a.info_source_id=b.id and a.id=".$row['id'];
			
		    $sub_row = mysql_fetch_array($sub_query);

		    $sub_sub_query = mysql_query("SELECT `labels`.* FROM `labels` INNER JOIN `analysis_categorizeds` ON `analysis_categorizeds`.`label_id` = `labels`.`id` WHERE `analysis_categorizeds`.`analysable_id` = "+$row['id']+" AND `analysis_categorizeds`.`analysable_type` = 'WeiboStatus' AND `labels`.`category_id` = 2");
			$product_label = "";
			while ($temp = mysql_fetch_array($sub_sub_query)) {
				$product_label=$product_label.$temp["str"]." ";
			}

			$sub_sub_query2 = mysql_query("SELECT `labels`.* FROM `labels` INNER JOIN `analysis_categorizeds` ON `analysis_categorizeds`.`label_id` = `labels`.`id` WHERE `analysis_categorizeds`.`analysable_id` = "+$row['id']+" AND `analysis_categorizeds`.`analysable_type` = 'WeiboStatus' AND `labels`.`category_id` = 3");
			$info_label = "";
			while ($temp = mysql_fetch_array($sub_sub_query2)) {
				$info_label=$info_label.$temp["str"]." ";
			}
		    

		    $urgency =""
		    if($sub_row['sentiment']==1){
				$tonality = "正面";
			}else if($sub_row['sentiment']==2){
				$tonality = "负面";
				if ($sub_row['urgency']<=1) {
					$urgency ="一般级";
				}else if ($sub_row['urgency']==2) {
					$urgency ="关注级";
				}else if ($sub_row['urgency']==3) {
					$urgency ="干预级";
				}else if ($sub_row['urgency']==4) {
					$urgency ="危机级";
				}else if ($sub_row['urgency']==5) {
					$urgency ="重大危机级";
				}
			}else{
				$tonality = "中性";
			}

			$objPHPExcel->getActiveSheet()->setCellValue("A".$i,strval($i-1));  		
			$objPHPExcel->getActiveSheet()->setCellValue("B".$i,$sitename);		
			$objPHPExcel->getActiveSheet()->setCellValue("C".$i,$product_label);		
			$objPHPExcel->getActiveSheet()->setCellValue("D".$i,$info_label);
		    $objPHPExcel->getActiveSheet()->setCellValue("E".$i,$tonality);
		    $objPHPExcel->getActiveSheet()->setCellValue("F".$i,$urgency);  
		    $objPHPExcel->getActiveSheet()->setCellValue("G".$i,$type);
		    $objPHPExcel->getActiveSheet()->setCellValue("H".$i,$sub_row['str']); 
		    $objPHPExcel->getActiveSheet()->setCellValue("I".$i,$sub_row['weibo_user_screen_name']);
		    $objPHPExcel->getActiveSheet()->setCellValue("J".$i,$sub_row['follower_count']);
		    $objPHPExcel->getActiveSheet()->setCellValue("K".$i,$sub_row['text']);
		    $objPHPExcel->getActiveSheet()->setCellValue("L".$i,$sub_row['repost_count']);
		    $objPHPExcel->getActiveSheet()->setCellValue("M".$i,$sub_row['comment_count']);
		    $objPHPExcel->getActiveSheet()->setCellValue("N".$i,$sub_row['url']);
		    $objPHPExcel->getActiveSheet()->setCellValue("O".$i,$sub_row['geo_info_province']."-".$sub_row['geo_info_city']);
		    $objPHPExcel->getActiveSheet()->setCellValue("P".$i,$sub_row['created_at']);


		   
		}
	}else if($type=="bbs"){
		$objPHPExcel = new PHPExcel();  
		$objPHPExcel = PHPExcel_IOFactory::load("bbs.xls");
		$objPHPExcel->setActiveSheetIndex(0);
		
		header("Content-Type: application/vnd.ms-excel; charset=UTF-8");
		header('Content-Disposition: attachment;filename="BBS - Daily Report Brief '.date("Y-m-d").'.xls"');
		header('Cache-Control: max-age=0');
			
		
		$query=mysql_query("SELECT a.* FROM bbs_posts a, operations c WHERE a.created_at BETWEEN '". date("Y-m-d G:i:s",$d1/1000)."' AND '". date("Y-m-d G:i:s",$d2/1000)."' and c.handled=1  and c.ignored=0 and c.operatable_id = a.id and c.operatable_type ='BbsPost' ORDER BY created_at DESC");
		$i=1;
		while($row = mysql_fetch_array($query)) {
			$i++;
			$sub_query=mysql_query("select b.str from bbs_posts a, info_sources b where a.info_source_id=b.id and a.id=".$row['id']);
			//echo "select b.str from weibo_statuses a, info_sources b where a.info_source_id=b.id and a.id=".$row['id'];
			
		    $sub_row = mysql_fetch_array($sub_query);

		   	$sub_sub_query = mysql_query("SELECT `labels`.* FROM `labels` INNER JOIN `analysis_categorizeds` ON `analysis_categorizeds`.`label_id` = `labels`.`id` WHERE `analysis_categorizeds`.`analysable_id` = "+$row['id']+" AND `analysis_categorizeds`.`analysable_type` = 'BbsPost' AND `labels`.`category_id` = 2");
			$product_label = "";
			while ($temp = mysql_fetch_array($sub_sub_query)) {
				$product_label=$product_label.$temp["str"]." ";
			}

			$sub_sub_query2 = mysql_query("SELECT `labels`.* FROM `labels` INNER JOIN `analysis_categorizeds` ON `analysis_categorizeds`.`label_id` = `labels`.`id` WHERE `analysis_categorizeds`.`analysable_id` = "+$row['id']+" AND `analysis_categorizeds`.`analysable_type` = 'BbsPost' AND `labels`.`category_id` = 3");
			$info_label = "";
			while ($temp = mysql_fetch_array($sub_sub_query2)) {
				$info_label=$info_label.$temp["str"]." ";
			}
		    
		   $urgency =""
		    if($sub_row['sentiment']==1){
				$tonality = "正面";
			}else if($sub_row['sentiment']==2){
				$tonality = "负面";
				if ($sub_row['urgency']<=1) {
					$urgency ="一般级";
				}else if ($sub_row['urgency']==2) {
					$urgency ="关注级";
				}else if ($sub_row['urgency']==3) {
					$urgency ="干预级";
				}else if ($sub_row['urgency']==4) {
					$urgency ="危机级";
				}else if ($sub_row['urgency']==5) {
					$urgency ="重大危机级";
				}
			}else{
				$tonality = "中性";
			}


			$objPHPExcel->getActiveSheet()->setCellValue("A".$i,strval($i-1));  		
			$objPHPExcel->getActiveSheet()->setCellValue("B".$i,$sitename);		
			$objPHPExcel->getActiveSheet()->setCellValue("C".$i,$product_label);		
			$objPHPExcel->getActiveSheet()->setCellValue("D".$i,$info_label);
		    $objPHPExcel->getActiveSheet()->setCellValue("E".$i,$tonality);
		    $objPHPExcel->getActiveSheet()->setCellValue("F".$i,$urgency);  
		    $objPHPExcel->getActiveSheet()->setCellValue("G".$i,$type);
		    $objPHPExcel->getActiveSheet()->setCellValue("H".$i,$sub_row['str']); 
		    $objPHPExcel->getActiveSheet()->setCellValue("I".$i,$sub_row['bbs_user_screen_name']);
		    $objPHPExcel->getActiveSheet()->setCellValue("J".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("K".$i,$sub_row['title']);
		    $objPHPExcel->getActiveSheet()->setCellValue("L".$i,$sub_row['read_count']);
		    $objPHPExcel->getActiveSheet()->setCellValue("M".$i,$sub_row['comment_count']);
		    $objPHPExcel->getActiveSheet()->setCellValue("N".$i,$sub_row['url']);
		    $objPHPExcel->getActiveSheet()->setCellValue("O".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("P".$i,$sub_row['created_at']);

		   
		}
	}else if($type=="blog"){
		$objPHPExcel = new PHPExcel();  
		$objPHPExcel = PHPExcel_IOFactory::load("blog.xls");
		$objPHPExcel->setActiveSheetIndex(0);
		
		header("Content-Type: application/vnd.ms-excel; charset=UTF-8");
		header('Content-Disposition: attachment;filename="BLOG - Daily Report Brief '.date("Y-m-d").'.xls"');
		header('Cache-Control: max-age=0');
			
		
		$query=mysql_query("SELECT a.* FROM blog_posts a, operations c WHERE a.created_at BETWEEN '". date("Y-m-d G:i:s",$d1/1000)."' AND '". date("Y-m-d G:i:s",$d2/1000)."' and c.handled=1 and c.ignored=0 and c.operatable_id = a.id and c.operatable_type ='BlogPost' ORDER BY created_at DESC");
		$i=1;
		while($row = mysql_fetch_array($query)) {
			$i++;
			$sub_query=mysql_query("select b.str from blog_posts a, info_sources b where a.info_source_id=b.id and a.id=".$row['id']);
			//echo "select b.str from weibo_statuses a, info_sources b where a.info_source_id=b.id and a.id=".$row['id'];
			
		    $sub_row = mysql_fetch_array($sub_query);

		    $sub_sub_query = mysql_query("SELECT `labels`.* FROM `labels` INNER JOIN `analysis_categorizeds` ON `analysis_categorizeds`.`label_id` = `labels`.`id` WHERE `analysis_categorizeds`.`analysable_id` = "+$row['id']+" AND `analysis_categorizeds`.`analysable_type` = 'BlogPost' AND `labels`.`category_id` = 2");
			$product_label = "";
			while ($temp = mysql_fetch_array($sub_sub_query)) {
				$product_label=$product_label.$temp["str"]." ";
			}

			$sub_sub_query2 = mysql_query("SELECT `labels`.* FROM `labels` INNER JOIN `analysis_categorizeds` ON `analysis_categorizeds`.`label_id` = `labels`.`id` WHERE `analysis_categorizeds`.`analysable_id` = "+$row['id']+" AND `analysis_categorizeds`.`analysable_type` = 'BlogPost' AND `labels`.`category_id` = 3");
			$info_label = "";
			while ($temp = mysql_fetch_array($sub_sub_query2)) {
				$info_label=$info_label.$temp["str"]." ";
			}
		    
		   $urgency =""
		    if($sub_row['sentiment']==1){
				$tonality = "正面";
			}else if($sub_row['sentiment']==2){
				$tonality = "负面";
				if ($sub_row['urgency']<=1) {
					$urgency ="一般级";
				}else if ($sub_row['urgency']==2) {
					$urgency ="关注级";
				}else if ($sub_row['urgency']==3) {
					$urgency ="干预级";
				}else if ($sub_row['urgency']==4) {
					$urgency ="危机级";
				}else if ($sub_row['urgency']==5) {
					$urgency ="重大危机级";
				}
			}else{
				$tonality = "中性";
			}


			$objPHPExcel->getActiveSheet()->setCellValue("A".$i,strval($i-1));  		
			$objPHPExcel->getActiveSheet()->setCellValue("B".$i,$sitename);		
			$objPHPExcel->getActiveSheet()->setCellValue("C".$i,$product_label);		
			$objPHPExcel->getActiveSheet()->setCellValue("D".$i,$info_label);
		    $objPHPExcel->getActiveSheet()->setCellValue("E".$i,$tonality);
		    $objPHPExcel->getActiveSheet()->setCellValue("F".$i,$urgency);  
		    $objPHPExcel->getActiveSheet()->setCellValue("G".$i,$type);
		    $objPHPExcel->getActiveSheet()->setCellValue("H".$i,$sub_row['str']); 
		    $objPHPExcel->getActiveSheet()->setCellValue("I".$i,$sub_row['blog_user_screen_name']);
		    $objPHPExcel->getActiveSheet()->setCellValue("J".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("K".$i,$sub_row['title']);
		    $objPHPExcel->getActiveSheet()->setCellValue("L".$i,$sub_row['read_count']);
		    $objPHPExcel->getActiveSheet()->setCellValue("M".$i,$sub_row['comment_count']);
		    $objPHPExcel->getActiveSheet()->setCellValue("N".$i,$sub_row['url']);
		    $objPHPExcel->getActiveSheet()->setCellValue("O".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("P".$i,$sub_row['created_at']);

		   
		}
	}else if($type=="wiki"){
		$objPHPExcel = new PHPExcel();  
		$objPHPExcel = PHPExcel_IOFactory::load("wiki.xls");
		$objPHPExcel->setActiveSheetIndex(0);
		
		header("Content-Type: application/vnd.ms-excel; charset=UTF-8");
		header('Content-Disposition: attachment;filename="WIKI - Daily Report Brief '.date("Y-m-d").'.xls"');
		header('Cache-Control: max-age=0');
			
		
		$query=mysql_query("SELECT a.* FROM wiki_posts a, operations c WHERE a.created_at BETWEEN '". date("Y-m-d G:i:s",$d1/1000)."' AND '". date("Y-m-d G:i:s",$d2/1000)."' and c.handled=1 and c.ignored=0 and c.operatable_id = a.id and c.operatable_type ='WikiPost' ORDER BY created_at DESC");
		$i=1;
		while($row = mysql_fetch_array($query)) {
			$i++;
			$sub_query=mysql_query("select b.str from wiki_posts a, info_sources b where a.info_source_id=b.id and a.id=".$row['id']);
			//echo "select b.str from weibo_statuses a, info_sources b where a.info_source_id=b.id and a.id=".$row['id'];
			
		    $sub_row = mysql_fetch_array($sub_query);
		    $sub_sub_query = mysql_query("SELECT `labels`.* FROM `labels` INNER JOIN `analysis_categorizeds` ON `analysis_categorizeds`.`label_id` = `labels`.`id` WHERE `analysis_categorizeds`.`analysable_id` = "+$row['id']+" AND `analysis_categorizeds`.`analysable_type` = 'WikiPost' AND `labels`.`category_id` = 2");
			$product_label = "";
			while ($temp = mysql_fetch_array($sub_sub_query)) {
				$product_label=$product_label.$temp["str"]." ";
			}

			$sub_sub_query2 = mysql_query("SELECT `labels`.* FROM `labels` INNER JOIN `analysis_categorizeds` ON `analysis_categorizeds`.`label_id` = `labels`.`id` WHERE `analysis_categorizeds`.`analysable_id` = "+$row['id']+" AND `analysis_categorizeds`.`analysable_type` = 'WikiPost' AND `labels`.`category_id` = 3");
			$info_label = "";
			while ($temp = mysql_fetch_array($sub_sub_query2)) {
				$info_label=$info_label.$temp["str"]." ";
			}
		    
		    $urgency =""
		    if($sub_row['sentiment']==1){
				$tonality = "正面";
			}else if($sub_row['sentiment']==2){
				$tonality = "负面";
				if ($sub_row['urgency']<=1) {
					$urgency ="一般级";
				}else if ($sub_row['urgency']==2) {
					$urgency ="关注级";
				}else if ($sub_row['urgency']==3) {
					$urgency ="干预级";
				}else if ($sub_row['urgency']==4) {
					$urgency ="危机级";
				}else if ($sub_row['urgency']==5) {
					$urgency ="重大危机级";
				}
			}else{
				$tonality = "中性";
			}


			$objPHPExcel->getActiveSheet()->setCellValue("A".$i,strval($i-1));  		
			$objPHPExcel->getActiveSheet()->setCellValue("B".$i,$sitename);		
			$objPHPExcel->getActiveSheet()->setCellValue("C".$i,$product_label);		
			$objPHPExcel->getActiveSheet()->setCellValue("D".$i,$info_label);
		    $objPHPExcel->getActiveSheet()->setCellValue("E".$i,$tonality);
		    $objPHPExcel->getActiveSheet()->setCellValue("F".$i,$urgency);  
		    $objPHPExcel->getActiveSheet()->setCellValue("G".$i,$type);
		    $objPHPExcel->getActiveSheet()->setCellValue("H".$i,$sub_row['str']); 
		    $objPHPExcel->getActiveSheet()->setCellValue("I".$i,$sub_row['wiki_user_screen_name']);
		    $objPHPExcel->getActiveSheet()->setCellValue("J".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("K".$i,$sub_row['title']);
		    $objPHPExcel->getActiveSheet()->setCellValue("L".$i,$sub_row['read_count']);
		    $objPHPExcel->getActiveSheet()->setCellValue("M".$i,$sub_row['comment_count']);
		    $objPHPExcel->getActiveSheet()->setCellValue("N".$i,$sub_row['url']);
		    $objPHPExcel->getActiveSheet()->setCellValue("O".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("P".$i,$sub_row['created_at']);

		   
		}
	}else if($type=="news"){
		$objPHPExcel = new PHPExcel();  
		$objPHPExcel = PHPExcel_IOFactory::load("news.xls");
		$objPHPExcel->setActiveSheetIndex(0);
		
		header("Content-Type: application/vnd.ms-excel; charset=UTF-8");
		header('Content-Disposition: attachment;filename="NEWS - Daily Report Brief '.date("Y-m-d").'.xls"');
		header('Cache-Control: max-age=0');
			
		
		$query=mysql_query("SELECT a.* FROM news a, operations c WHERE a.created_at BETWEEN '". date("Y-m-d G:i:s",$d1/1000)."' AND '". date("Y-m-d G:i:s",$d2/1000)."' and c.handled=1 and c.ignored=0 and c.operatable_id = a.id and c.operatable_type ='News' ORDER BY created_at DESC");
		$i=1;
		while($row = mysql_fetch_array($query)) {
			$i++;
			$sub_query=mysql_query("select b.str from news a, info_sources b where a.info_source_id=b.id and a.id=".$row['id']);
			//echo "select b.str from weibo_statuses a, info_sources b where a.info_source_id=b.id and a.id=".$row['id'];
			
		    $sub_row = mysql_fetch_array($sub_query);

		    $sub_sub_query = mysql_query("SELECT `labels`.* FROM `labels` INNER JOIN `analysis_categorizeds` ON `analysis_categorizeds`.`label_id` = `labels`.`id` WHERE `analysis_categorizeds`.`analysable_id` = "+$row['id']+" AND `analysis_categorizeds`.`analysable_type` = 'News' AND `labels`.`category_id` = 2");
			$product_label = "";
			while ($temp = mysql_fetch_array($sub_sub_query)) {
				$product_label=$product_label.$temp["str"]." ";
			}

			$sub_sub_query2 = mysql_query("SELECT `labels`.* FROM `labels` INNER JOIN `analysis_categorizeds` ON `analysis_categorizeds`.`label_id` = `labels`.`id` WHERE `analysis_categorizeds`.`analysable_id` = "+$row['id']+" AND `analysis_categorizeds`.`analysable_type` = 'News' AND `labels`.`category_id` = 3");
			$info_label = "";
			while ($temp = mysql_fetch_array($sub_sub_query2)) {
				$info_label=$info_label.$temp["str"]." ";
			}
		    
		    $urgency =""
		    if($sub_row['sentiment']==1){
				$tonality = "正面";
			}else if($sub_row['sentiment']==2){
				$tonality = "负面";
				if ($sub_row['urgency']<=1) {
					$urgency ="一般级";
				}else if ($sub_row['urgency']==2) {
					$urgency ="关注级";
				}else if ($sub_row['urgency']==3) {
					$urgency ="干预级";
				}else if ($sub_row['urgency']==4) {
					$urgency ="危机级";
				}else if ($sub_row['urgency']==5) {
					$urgency ="重大危机级";
				}
			}else{
				$tonality = "中性";
			}

			$objPHPExcel->getActiveSheet()->setCellValue("A".$i,strval($i-1));  		
			$objPHPExcel->getActiveSheet()->setCellValue("B".$i,$sitename);		
			$objPHPExcel->getActiveSheet()->setCellValue("C".$i,$product_label);		
			$objPHPExcel->getActiveSheet()->setCellValue("D".$i,$info_label);
		    $objPHPExcel->getActiveSheet()->setCellValue("E".$i,$tonality);
		    $objPHPExcel->getActiveSheet()->setCellValue("F".$i,$urgency);  
		    $objPHPExcel->getActiveSheet()->setCellValue("G".$i,$type);
		    $objPHPExcel->getActiveSheet()->setCellValue("H".$i,$sub_row['str']); 
		    $objPHPExcel->getActiveSheet()->setCellValue("I".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("J".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("K".$i,$sub_row['title']);
		    $objPHPExcel->getActiveSheet()->setCellValue("L".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("M".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("N".$i,$sub_row['url']);
		    $objPHPExcel->getActiveSheet()->setCellValue("O".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("P".$i,$sub_row['created_at']);


		}
	}else if($type=="video"){
		$objPHPExcel = new PHPExcel();  
		$objPHPExcel = PHPExcel_IOFactory::load("video.xls");
		$objPHPExcel->setActiveSheetIndex(0);
		
		header("Content-Type: application/vnd.ms-excel; charset=UTF-8");
		header('Content-Disposition: attachment;filename="VIDEO - Daily Report Brief '.date("Y-m-d").'.xls"');
		header('Cache-Control: max-age=0');
			
		
		$query=mysql_query("SELECT a.* FROM video_posts a, operations c WHERE a.created_at BETWEEN '". date("Y-m-d G:i:s",$d1/1000)."' AND '". date("Y-m-d G:i:s",$d2/1000)."' and c.handled=1 and c.ignored=0 and c.operatable_id = a.id and c.operatable_type ='VideoPost' ORDER BY created_at DESC");
		$i=1;
		while($row = mysql_fetch_array($query)) {
			$i++;
			$sub_query=mysql_query("select b.str from video_posts a, info_sources b where a.info_source_id=b.id and a.id=".$row['id']);
			//echo "select b.str from weibo_statuses a, info_sources b where a.info_source_id=b.id and a.id=".$row['id'];
			
		    $sub_row = mysql_fetch_array($sub_query);


		    $sub_sub_query = mysql_query("SELECT `labels`.* FROM `labels` INNER JOIN `analysis_categorizeds` ON `analysis_categorizeds`.`label_id` = `labels`.`id` WHERE `analysis_categorizeds`.`analysable_id` = "+$row['id']+" AND `analysis_categorizeds`.`analysable_type` = 'VideoPost' AND `labels`.`category_id` = 2");
			$product_label = "";
			while ($temp = mysql_fetch_array($sub_sub_query)) {
				$product_label=$product_label.$temp["str"]." ";
			}

			$sub_sub_query2 = mysql_query("SELECT `labels`.* FROM `labels` INNER JOIN `analysis_categorizeds` ON `analysis_categorizeds`.`label_id` = `labels`.`id` WHERE `analysis_categorizeds`.`analysable_id` = "+$row['id']+" AND `analysis_categorizeds`.`analysable_type` = 'VideoPost' AND `labels`.`category_id` = 3");
			$info_label = "";
			while ($temp = mysql_fetch_array($sub_sub_query2)) {
				$info_label=$info_label.$temp["str"]." ";
			}
		    
		    $urgency =""
		    if($sub_row['sentiment']==1){
				$tonality = "正面";
			}else if($sub_row['sentiment']==2){
				$tonality = "负面";
				if ($sub_row['urgency']<=1) {
					$urgency ="一般级";
				}else if ($sub_row['urgency']==2) {
					$urgency ="关注级";
				}else if ($sub_row['urgency']==3) {
					$urgency ="干预级";
				}else if ($sub_row['urgency']==4) {
					$urgency ="危机级";
				}else if ($sub_row['urgency']==5) {
					$urgency ="重大危机级";
				}
			}else{
				$tonality = "中性";
			}

			$objPHPExcel->getActiveSheet()->setCellValue("A".$i,strval($i-1));  		
			$objPHPExcel->getActiveSheet()->setCellValue("B".$i,$sitename);		
			$objPHPExcel->getActiveSheet()->setCellValue("C".$i,$product_label);		
			$objPHPExcel->getActiveSheet()->setCellValue("D".$i,$info_label);
		    $objPHPExcel->getActiveSheet()->setCellValue("E".$i,$tonality);
		    $objPHPExcel->getActiveSheet()->setCellValue("F".$i,$urgency);  
		    $objPHPExcel->getActiveSheet()->setCellValue("G".$i,$type);
		    $objPHPExcel->getActiveSheet()->setCellValue("H".$i,$sub_row['str']); 
		    $objPHPExcel->getActiveSheet()->setCellValue("I".$i,$sub_row['video_user_screen_name']);
		    $objPHPExcel->getActiveSheet()->setCellValue("J".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("K".$i,$sub_row['title']);
		    $objPHPExcel->getActiveSheet()->setCellValue("L".$i,$sub_row['watch_count']);
		    $objPHPExcel->getActiveSheet()->setCellValue("M".$i,$sub_row['comment_count']);
		    $objPHPExcel->getActiveSheet()->setCellValue("N".$i,$sub_row['url']);
		    $objPHPExcel->getActiveSheet()->setCellValue("O".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("P".$i,$sub_row['created_at']);


		   
		}
	}else if($type=="opponent"){
		$objPHPExcel = new PHPExcel();  
		$objPHPExcel = PHPExcel_IOFactory::load("news.xls");
		$objPHPExcel->setActiveSheetIndex(0);
		
		header("Content-Type: application/vnd.ms-excel; charset=UTF-8");
		header('Content-Disposition: attachment;filename="NEWS - Daily Report Brief '.date("Y-m-d").'.xls"');
		header('Cache-Control: max-age=0');
			
		
		$query=mysql_query("SELECT a.* FROM opponent_news a WHERE a.created_at BETWEEN '". date("Y-m-d G:i:s",$d1/1000)."' AND '". date("Y-m-d G:i:s",$d2/1000)."' ORDER BY created_at DESC");
		$i=1;
		while($row = mysql_fetch_array($query)) {
			$i++;

			$objPHPExcel->getActiveSheet()->setCellValue("A".$i,strval($i-1));  		
			$objPHPExcel->getActiveSheet()->setCellValue("B".$i,$sitename);
		    $objPHPExcel->getActiveSheet()->setCellValue("C".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("D".$i,"");  
		    $objPHPExcel->getActiveSheet()->setCellValue("E".$i,$type);
		    $objPHPExcel->getActiveSheet()->setCellValue("F".$i,$row['source_name']); 
		    $objPHPExcel->getActiveSheet()->setCellValue("G".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("H".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("I".$i,$row['title']);
		    $objPHPExcel->getActiveSheet()->setCellValue("J".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("K".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("L".$i,$row['url']);
		    $objPHPExcel->getActiveSheet()->setCellValue("M".$i,"");
		    $objPHPExcel->getActiveSheet()->setCellValue("N".$i,$row['created_at']);
		   
		}
	}
	
	
	

mysql_close($link);

$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel5');
$objWriter->save('php://output');
exit;


}

?>