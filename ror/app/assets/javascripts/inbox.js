	
	/*
		时间format
	*/
	Date.prototype.to_s = function() {
		var mm = this.getMonth() + 1;
		var dd = this.getDate();
		if (mm < 10)
			mm = '0' + mm;
		if (dd < 10)
			dd = '0' + dd;
		return this.getFullYear() + '-' + mm + '-' + dd;
	};
	
	/*
		高亮关键字及@后用户名
	*/
	function highlight(selector){
		selector.each(function(){
			var regEx = new RegExp(/ *@([{\u4e00-\u9fa5}A-Za-z0-9_-]*) ?/g);
			var str = $(this).text();
			var tmpstr=str.replace(regEx, "<a>@$1</a>");
			var keywords= $(this).parent().parent().attr('key');
			var keys=keywords.split(" ");
			for(var i=0;i<keys.length;i++){
				var reg=new RegExp("("+keys[i]+")","g"); 
				tmpstr=tmpstr.replace(reg,"<em>$1</em>");
			}
			$(this).html(tmpstr);
		});
	}
	
	var pagenum = 0; //pagenumber
	var infotype=$(".maincontent").attr("id");; //动态加载的内容
	
	var filter="unhandle";
	var start=0; //查询初始时间
	var end=0;   //查询截止时间
	var filtervalue=0; //filter值
	
	
	$(function() {
		
		
		var ignored_p=$(".ignored").find("em");
		var unhandle_p=$(".nohandle").find("em");
		var handled_p=$(".handled").find("em");
		
		var ignored_num=parseInt(ignored_p.html());
		var unhandle_num=parseInt(unhandle_p.html());
		var handled_num=parseInt(handled_p.html());
		
		loadMore();


		/* 关注操作 */
		$(".focus").live('click',function(){
			$("#alert").show();
			$(this).addClass("unfocus");
			$(this).removeClass("focus");
			$(this).find("i").addClass("icon-eye-close");
			$(this).find("i").removeClass("icon-eye-open");
			var theid=$(this).parent().parent().parent().parent().attr('id');
			$.get('/inbox/monitor/'+theid,function(data){
				if(data=="OK"){
					var mnum=parseInt($(".mnum").html());
					$(".mnum").html(mnum+1);
					$("#alert").hide();
				}
			})
			.fail(function() { alert("操作失败，请联系管理员");});
		});
		
		
		/* 取消关注操作 */
		$(".unfocus").live('click',function(){
			$("#alert").show();
			$(this).addClass("focus");
			$(this).removeClass("unfocus");
			$(this).find("i").addClass("icon-eye-open");
			$(this).find("i").removeClass("icon-eye-close");
			var theid=$(this).parent().parent().parent().parent().attr('id');
			$.get('/inbox/unmonitor/'+theid,function(data) {
				if(data=="OK"){
					var mnum=parseInt($(".mnum").html());
					$(".mnum").html(mnum-1);
					$("#alert").hide();
				}
			})
			.fail(function() { alert("操作失败，请联系管理员");});
		});
		
		
		/* 忽略操作 */
		$(".ignore").live('click',function(){
			$("#alert").show();
			var thep=$(this).parent().parent().parent().parent();
			var theid=thep.attr('id');
			//alert('/inbox/'+infotype+'/'+theid+'/ignore');
			$.get('/inbox/'+infotype+'/'+theid+'/ignore',function(data) {
				if(data=="OK"){
					if(filter=="unhandle"){
						unhandle_num--;
						unhandle_p.html(unhandle_num);
						ignored_num++;
						ignored_p.html(ignored_num);
					}else if(filter=="handled"){
						handled_num--;
						handled_p.html(handled_num);
						ignored_num++;
						ignored_p.html(ignored_num);
					}
					thep.remove();
					$("#alert").hide();
					if($("#main-containt").find("blockquote").size()<1){
						pagenum=0;
						$("#main-containt").html("");
						loadMore();
					}
				}
			})
			.fail(function() { alert("操作失败，请联系管理员");});
			
		});
		
		
		/* 取消忽略操作 */
		$(".unignore").live('click',function(){
			$("#alert").show();
			var thep=$(this).parent().parent().parent().parent()
			var theid=thep.attr('id');
			
			$.get('/inbox/'+infotype+'/'+theid+'/unignore',function(data) {
				if(data=="OK"){
				unhandle_num++;
				unhandle_p.html(unhandle_num);
				ignored_num--; 
				ignored_p.html(ignored_num);
				thep.remove();
				$("#alert").hide();
				if($("#main-containt").find("blockquote").size()<1)
					loadMore();
				}
			})
			.fail(function() { alert("操作失败，请联系管理员");});
			
			
		});
		
		/* 设置预警等级操作 */
		$(".stars li").live('click',
			function() {
				$("#alert").show();
				var theid=$(this).parent().parent().parent().parent().parent().attr('id');
				$(this).parent().removeClass();
				$(this).parent().addClass("stars stars"+($(this).index() + 1));
				//alert('/inbox/'+infotype+'/'+theid+'/set_urgency/'+($(this).index() + 1));
			    $.get('/inbox/'+infotype+'/'+theid+'/set_urgency/'+($(this).index() + 1),function(data) {
			    	if(data=="OK")
					$("#alert").hide();
				})
				.fail(function() { alert("操作失败，请联系管理员");});
		});
		
		
		$(".ok_btn").live('click',function(){
			var dStartTime = $('#startTime');
			var dEndTime = $('#endTime');
			var dStartHours = $('#startHours');
			var dEndHours = $('#endHours');
			var d1=dStartTime.val()+" "+dStartHours.val()+":00:00";
			var d2=dEndTime.val()+" "+dEndHours.val()+":59:00";

			start=new Date(d1).getTime();
			end=new Date(d2).getTime();
			pagenum=0;
			order=$("#order").val();
			$("#main-containt").html("");
			//alert(start);
			loadMore();
			
			
		});
	
		
		/* 待处理的微博*/
		$(".nohandle").live('click',function(){
			pagenum=0;
			filter="unhandle";
			filtervalue=0;
			$("#main-containt").html("");
			loadMore();
			$(this).parent().find("li").removeClass('active');
			$(this).addClass('active');
		});
		/* 忽略的微博*/
		$(".ignored").live('click',function(){
			pagenum=0;
			filter="ignored";
			filtervalue=1;
			$("#main-containt").html("");
			loadMore();
			$(this).parent().find("li").removeClass('active');urgency
			$(this).addClass('active');
		});
		
		/* 处理完的微博*/
		$(".handled").live('click',function(){
			pagenum=0;
			filter="handled";
			filtervalue=1;
			$("#main-containt").html("");
			loadMore();
			$(this).parent().find("li").removeClass('active');
			$(this).addClass('active');
		});
		
		
		/* 处理按钮事件 */
		$(".btn_handled").live('click',function(){
			$("#alert").show();
			var p=$(this).parent().parent().parent();
			var theid=$(this).parent().parent().parent().attr('id');
			var thetags=p.find(".emotion").html().substring(0,2);
			p.find(".del_tag").each(function(){
				thetags=thetags+","+$(this).html();
			});
			//alert(p.html());
			//alert('${ctx}/classifier/modify?weibo_id='+theid+'&tags='+thetags);

		  	$.get('/inbox/'+infotype+'/'+theid+'/handle?tags='+thetags,function(data) {
		  		if(data=="OK"){
			  		$("#alert").hide();
			  		if(filter=="unhandle"){
						p.remove();
						unhandle_num--;
						unhandle_p.html(unhandle_num);
						handled_num++;
						handled_p.html(handled_num);
						if($("#main-containt").find("blockquote").size()<1){
							pagenum=0;
							$("#main-containt").html("");
							loadMore();
						}
					}
				}
				
			})
			.fail(function() { alert("操作失败，请联系管理员");});

			
		});
		
		
		
		
		
		
	
		
		$(".add_tag").live('click',function(){
			var val=$(this).html();
			var flag=0;
			$(this).parent().parent().parent().find(".del_tag").each(function(){
				
				if($(this).html()==val){
					flag=1;
				}
					//replaceWith('<a class="S_bg1 S_line1 S_link2 del_tag" title="删除这个标签" href="javascript:void(0);" cid="'+cid+'">'+$(this).html()+'</a>');
			});
			if(flag==0)
				$(this).parent().parent().parent().find(".wTablist2").prepend('<a class="S_bg1 S_line1 S_link2 del_tag" title="删除这个标签" href="javascript:void(0);">'+$(this).html()+'</a>');
		});
		
		$(".del_tag").live('click',function(){
			$(this).remove();
		});
		
		$(".icon_edit").live('click',
				function() {
					$(this).parent().parent().parent().parent()
							.parent().find(".edit_tags")
							.slideDown('fast');
				});
		$("body").live('click',
				function(e) {
					if (!$(e.target).is('div.edit_tags')
							&& !$(e.target).is('a.icon_edit')
							&& !$(e.target).is('a.S_link2')) {
						$(".edit_tags").slideUp('fast');
					}
				});
		$(".emotion").live('click',function() {
			if ($(this).hasClass("emotion_negative")) {
				$(this).addClass("emotion_positive");
				$(this).removeClass("emotion_negative");
				$(this).removeClass("emotion_neutral");
				$(this).html("正面消息");
			} else if ($(this).hasClass("emotion_positive")) {
				$(this).addClass("emotion_neutral");
				$(this).removeClass("emotion_negative");
				$(this).removeClass("emotion_positive");
				$(this).html("中性消息");
			} else if ($(this).hasClass("emotion_neutral")) {
				$(this).addClass("emotion_negative");
				$(this).removeClass("emotion_positive");
				$(this).removeClass("emotion_neutral");
				$(this).html("负面消息");
			}
		});

	
	});

	window.onscroll = function() {
		var winScroll = document.documentElement.scrollTop
				|| document.body.scrollTop;
		//console.log(winScroll+'  '+(document.body.offsetHeight - document.documentElement.clientHeight));
		if (winScroll == (document.body.offsetHeight - document.documentElement.clientHeight+42)) {
			
			loadMore();

		}
	};

	function loadMore() {
		$("#alert").show();
		//alert("${ctx}/inbox/"+infotype+"/ajaxlist?filter="+filter+"&page=" + pagenum+"&d1=" + start+"&d2=" + end+"&value=" + filtervalue);
		$.get("/inbox/"+infotype+"/"+pagenum+"?filter="+filter+"&d1=" + start+"&d2=" + end+"&sortType=" + order,
				function(data) {
					pagenum++;
					$("#main-containt").append(data);
					$("#alert").hide();
					highlight($(".weibo-txt"));
				}).error(function() {
					alert("全部加载完毕");
			
		});
	}