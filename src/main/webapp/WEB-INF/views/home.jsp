<!-- TODO STEP-4. view 생성   -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">


<link href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
 <style>
     img.img-responsiveMe { 
        position: relative;
      
    
      }
      img.img-responsive { 
        position: relative;
        right: 500px;
    
      }
      
    </style>

<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>

<link href="<c:url value="/resources/css/main.css" />" rel="stylesheet">
<script src="<c:url value="/resources/js/common.js" />"></script>
<title>웹 소켓 통신</title>
</head>
<body>

	
	<!------ Include the above in your HEAD tag ---------->
	
	<div class="container" style="width:300px;
    height:300px;
    position:absolute;
    left:42.5%;
    top:20%;
    margin-left:-150px;
    margin-top:-150px;">
	    <div class="row chat-window col-xs-5 col-md-3" id="chat_window_1" style="margin-left:10px;">
	        <div class="col-xs-12 col-md-12">
	        	<div class="panel panel-default">
	                <div class="panel-heading top-bar">
	                    <div class="col-md-8 col-xs-8">
	                        <h3 id="paneltitle" class="panel-title"><span class="glyphicon glyphicon-comment"></span> Chat - Miguel</h3>
	                    </div>
	                    <div class="col-md-4 col-xs-4" style="text-align: right;">
	                        <span id="minim_chat_window" class="glyphicon glyphicon-minus icon_minim"></span>
	                        <span class="glyphicon glyphicon-remove icon_close" data-id="chat_window_1"></span>
	                    </div>
	                </div>
	                <div class="panel-body msg_container_base">
	                    
	                </div>
	                <div class="panel-footer">
	                    <div class="input-group">
	                        <input id="btn-input" type="text" class="form-control input-sm chat_input" placeholder="Write your message here..." />
	                        <span class="input-group-btn">
	                        <button class="btn btn-primary btn-sm" id="btn-chat" onclick="send();">Send</button>
	                        </span>
	                    </div>
	                    <br/>
	                     <br/>
	                      <br/>
	
	         
	                </div>
	    		</div>
	        </div>
	    </div>
	    
	  
	</div>
                              <div style="width:500px;
    height:300px;
    position:absolute;
    left:15%;
    top:70%;
    margin-left:-75px;
    margin-top:-150px;">
        <button onclick="makeChattingRoom();">채팅방 설정,만들기</button>
        <button onclick="enterChattingRoom();">채팅방 접속하기</button>
        <button onclick="outChattingRoom();">채팅방 나가기</button>
    </div>


<!--     <div> -->
<!--         <input type="text" id="messageinput"> -->
<!--     </div> -->
    
   
    
    <div id="message"></div>
    <script>
    window.onload = function(){
    	if(!ws){
      $( '.container' ).hide();
    	}else{
    		
    		 $( '.container' ).show();
    	}
    
    }
    
    var htmlCode;
    var text;
        var ws;
        var messages = document.getElementById("message");
        var makeChattingTitle;
        var makeChattingNickName;
        function makeChattingRoom(){
        	var makeChatting = confirm('채팅방을 새로 여시겠습니까?');
          if(makeChatting==true){
        		makeChattingTitle = prompt('채팅방의 제목은 무엇으로 하시겠습니까?');  
        		if(makeChattingTitle==''){
        			alert("채팅방 제목을 설정해주세요");
        			return;
        		}else{
        		
        			makeChattingNickName = prompt('채팅방에서의 닉네임은 무엇으로 하시겠습니까?');
        		if(makeChattingNickName==''){
        			alert("채팅방 닉네임을 설정해주세요");
        			return;
        		}else{
        			 $( '.container' ).show();
        			
        			 document.getElementById("paneltitle").innerHTML=makeChattingTitle;
        		}
        		}
          }
        }
       
        function enterChattingRoom(){
        	
            if(ws!==undefined && ws.readyState!==WebSocket.CLOSED)
            {
                writeResponse("이미 채팅방에 참가한 상태입니다");
                return;
            } 
            
            //웹소켓 객체 만드는 코드
            ws = new WebSocket("ws://localhost:8000/web_socket/echo/websocket");
            writeResponse(makeChattingNickName+"님께서 채팅방에 참가하였습니다");
            
            ws.onopen=function(event){
            	
                if(event.data===undefined) return;
                writeResponse(event.data);
            };
            ws.onmessage=function(event){
            
                writeResponse(event.data);
            };
            ws.onclose=function(event){
            	var input = confirm('정말로 채팅방에서 나가시겠습니까?');

            	if(input==true){
                writeResponse(makeChattingNickName+"님께서 채팅방에 나갔습니다");
                $( '.container' ).hide();
                messages.innerHTML='';
                text="";
                htmlCode="";
                
                $('.msg_container_base').append(htmlCode);
            	}else{
            		 writeResponse("채팅방에 나가시는 걸 취소하였습니다");
            	}
            }
        }
        function send(){
           text = document.getElementById("btn-input").value;
         
            ws.send(makeChattingNickName+":"+text);
            text="";
        }
        function outChattingRoom(){
            ws.close();
        }
        function writeResponse(text){
        	var imgClass;
        	var PermuteText;
        	if(text.startsWith( '본인' )){
        		
        		PermuteText=text.replace('본인', '');
        		
        		imgClass='img-responsiveMe';
        		  message.innerHTML+="<br/>"+PermuteText;
                  
                  var now = new Date();
                  var nowHour = now.getHours();
                  var nowMt = now.getMinutes();
                  if ( nowHour <= 12  &&  nowHour  >= 6 ) {

                      
                      htmlCode = '<div class="row msg_container base_sent">';
                      htmlCode += '<div class="col-md-10 col-xs-10 ">';
                      htmlCode += '<div class="messages msg_sent">';
                      htmlCode += '<p>'+PermuteText+'</p>';
                      htmlCode += '<time datetime="2009-11-13T20:00">'+'오전 ' + nowHour + '시 ' + nowMt + '분 입니다.'+'</time>';
                      htmlCode += '</div></div>';
                      htmlCode += '<div class="col-md-2 col-xs-2 avatar">';
                      htmlCode += '<img src="http://www.bitrebels.com/wp-content/uploads/2011/02/Original-Facebook-Geek-Profile-Avatar-1.jpg" class=" img-responsiveMe ">';
                      htmlCode += '</div></div>';
                    } else if (  nowHour >= 12  &&  nowHour  < 22  ) {

                  
                      htmlCode = '<div class="row msg_container base_sent">';
                      htmlCode += '<div class="col-md-10 col-xs-10 ">';
                      htmlCode += '<div class="messages msg_sent">';
                      htmlCode += '<p>'+PermuteText+'</p>';
                      htmlCode += '<time datetime="2009-11-13T20:00">'+'오후 ' + (nowHour-12) + '시 ' + nowMt + '분 입니다.'+'</time>';
                      htmlCode += '</div></div>';
                      htmlCode += '<div class="col-md-2 col-xs-2 avatar">';
                      htmlCode += '<img src="http://www.bitrebels.com/wp-content/uploads/2011/02/Original-Facebook-Geek-Profile-Avatar-1.jpg" class=" img-responsiveMe " style="float: left;">';
                      htmlCode += '</div></div>';
                    } else if ( nowHour >= 22  &&  nowHour  <= 24  ) {

                    
                       htmlCode = '<div class="row msg_container base_sent">';
                      htmlCode += '<div class="col-md-10 col-xs-10 ">';
                      htmlCode += '<div class="messages msg_sent">';
                      htmlCode += '<p>'+PermuteText+'</p>';
                      htmlCode += '<time datetime="2009-11-13T20:00">'+'밤 ' + (nowHour-12) + '시 ' + nowMt + '분 입니다.'+'</time>';
                      htmlCode += '</div></div>';
                      htmlCode += '<div class="col-md-2 col-xs-2 avatar">';
                      htmlCode += '<img src="http://www.bitrebels.com/wp-content/uploads/2011/02/Original-Facebook-Geek-Profile-Avatar-1.jpg" class=" img-responsiveMe " style="float: left;">';
                      htmlCode += '</div></div>';
                    } else {

                    
                       htmlCode = '<div class="row msg_container base_sent">';
                      htmlCode += '<div class="col-md-10 col-xs-10 ">';
                      htmlCode += '<div class="messages msg_sent">';
                      htmlCode += '<p>'+PermuteText+'</p>';
                      htmlCode += '<time datetime="2009-11-13T20:00">'+'새벽 ' + nowHour + '시 ' + nowMt + '분 입니다.'+'</time>';
                      htmlCode += '</div></div>';
                      htmlCode += '<div class="col-md-2 col-xs-2 avatar">';
                      htmlCode += '<img src="http://www.bitrebels.com/wp-content/uploads/2011/02/Original-Facebook-Geek-Profile-Avatar-1.jpg" class="img-responsiveMe ">';
                      htmlCode += '</div></div>';
                    }
                  
        	}else{
        	
            message.innerHTML+="<br/>"+text;
            
            var now = new Date();
            var nowHour = now.getHours();
            var nowMt = now.getMinutes();
            if ( nowHour <= 12  &&  nowHour  >= 6 ) {

                
               htmlCode = '<div class="row msg_container base_receive">';
                htmlCode += '<div class="col-md-10 col-xs-10 ">';
                htmlCode += '<div class="messages msg_receive">';
                htmlCode += '<p>'+text+'</p>';
                htmlCode += '<time datetime="2009-11-13T20:00">'+'오전 ' + nowHour + '시 ' + nowMt + '분 입니다.'+'</time>';
                htmlCode += '</div></div>';
                htmlCode += '<div class="col-md-2 col-xs-2 avatar">';
                htmlCode += '<img src="http://www.bitrebels.com/wp-content/uploads/2011/02/Original-Facebook-Geek-Profile-Avatar-1.jpg" class=" img-responsive ">';
                htmlCode += '</div></div>';
              } else if (  nowHour >= 12  &&  nowHour  < 22  ) {

            
                htmlCode = '<div class="row msg_container base_receive">';
                htmlCode += '<div class="col-md-10 col-xs-10 ">';
                htmlCode += '<div class="messages msg_receive">';
                htmlCode += '<p>'+text+'</p>';
                htmlCode += '<time datetime="2009-11-13T20:00">'+'오후 ' + (nowHour-12) + '시 ' + nowMt + '분 입니다.'+'</time>';
                htmlCode += '</div></div>';
                htmlCode += '<div class="col-md-2 col-xs-2 avatar">';
                htmlCode += '<img src="http://www.bitrebels.com/wp-content/uploads/2011/02/Original-Facebook-Geek-Profile-Avatar-1.jpg" class=" img-responsive " style="float: left;">';
                htmlCode += '</div></div>';
              } else if ( nowHour >= 22  &&  nowHour  <= 24  ) {

              
                htmlCode = '<div class="row msg_container base_receive">';
                htmlCode += '<div class="col-md-10 col-xs-10 ">';
                htmlCode += '<div class="messages msg_receive">';
                htmlCode += '<p>'+text+'</p>';
                htmlCode += '<time datetime="2009-11-13T20:00">'+'밤 ' + (nowHour-12) + '시 ' + nowMt + '분 입니다.'+'</time>';
                htmlCode += '</div></div>';
                htmlCode += '<div class="col-md-2 col-xs-2 avatar">';
                htmlCode += '<img src="http://www.bitrebels.com/wp-content/uploads/2011/02/Original-Facebook-Geek-Profile-Avatar-1.jpg" class=" img-responsive " style="float: left;">';
                htmlCode += '</div></div>';
              } else {

              
                 htmlCode = '<div class="row msg_container base_receive">';
                htmlCode += '<div class="col-md-10 col-xs-10 ">';
                htmlCode += '<div class="messages msg_receive">';
                htmlCode += '<p>'+text+'</p>';
                htmlCode += '<time datetime="2009-11-13T20:00">'+'새벽 ' + nowHour + '시 ' + nowMt + '분 입니다.'+'</time>';
                htmlCode += '</div></div>';
                htmlCode += '<div class="col-md-2 col-xs-2 avatar">';
                htmlCode += '<img src="http://www.bitrebels.com/wp-content/uploads/2011/02/Original-Facebook-Geek-Profile-Avatar-1.jpg" class=" img-responsive ">';
                htmlCode += '</div></div>';
              }
        	}
            
            
            
            $('.msg_container_base').append(htmlCode);
            
            $('.msg_container_base').scrollTop($('.msg_container_base')[0].scrollHeight);
            $('#btn-input').val('');
        }
    </script>
</body>
</html>
