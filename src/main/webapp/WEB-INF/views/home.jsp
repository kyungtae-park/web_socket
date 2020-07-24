<!-- TODO STEP-4. view 생성   -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">


<link href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>

<link href="<c:url value="/resources/css/main.css" />" rel="stylesheet">
<script src="<c:url value="/resources/js/common.js" />"></script>
<title>웹 소켓 통신</title>
</head>
<body>

	
	<!------ Include the above in your HEAD tag ---------->
	
	<div class="container">
	    <div class="row chat-window col-xs-5 col-md-3" id="chat_window_1" style="margin-left:10px;">
	        <div class="col-xs-12 col-md-12">
	        	<div class="panel panel-default">
	                <div class="panel-heading top-bar">
	                    <div class="col-md-8 col-xs-8">
	                        <h3 class="panel-title"><span class="glyphicon glyphicon-comment"></span> Chat - Miguel</h3>
	                    </div>
	                    <div class="col-md-4 col-xs-4" style="text-align: right;">
	                        <a href="#"><span id="minim_chat_window" class="glyphicon glyphicon-minus icon_minim"></span></a>
	                        <a href="#"><span class="glyphicon glyphicon-remove icon_close" data-id="chat_window_1"></span></a>
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
	                </div>
	    		</div>
	        </div>
	    </div>
	    
	    <div class="btn-group dropup">
	        <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
	            <span class="glyphicon glyphicon-cog"></span>
	            <span class="sr-only">Toggle Dropdown</span>
	        </button>
	        <ul class="dropdown-menu" role="menu">
	            <li><a href="#" id="new_chat"><span class="glyphicon glyphicon-plus"></span> Novo</a></li>
	            <li><a href="#"><span class="glyphicon glyphicon-list"></span> Ver outras</a></li>
	            <li><a href="#"><span class="glyphicon glyphicon-remove"></span> Fechar Tudo</a></li>
	            <li class="divider"></li>
	            <li><a href="#"><span class="glyphicon glyphicon-eye-close"></span> Invisivel</a></li>
	        </ul>
	    </div>
	</div>



    <div>
        <input type="text" id="messageinput">
    </div>
    
    <div>
        <button onclick="openSocket();">Open</button>
        <button >Send</button>
        <button onclick="closeSocket();">close</button>
    </div>
    
    <div id="message"></div>
    <script>
        var ws;
        var messages = document.getElementById("message");
        
        function openSocket(){
            if(ws!==undefined && ws.readyState!==WebSocket.CLOSED)
            {
                writeResponse("WebSocket is already opend.");
                return;
            } 
            
            //웹소켓 객체 만드는 코드
            ws = new WebSocket('ws://localhost:8080/swp/echo');
            
            ws.onopen=function(event){
                if(event.data===undefined) return;
                writeResponse(event.data);
            };
            ws.onmessage=function(event){
                writeResponse(event.data);
            };
            ws.onclose=function(event){
                writeResponse("Connection closed");
            }
        }
        function send(){
            var text = document.getElementById("btn-input").value;
            ws.send(text);
            text="";
        }
        function closeSocket(){
            ws.close();
        }
        function writeResponse(text){
        	
            message.innerHTML+="<br/>"+text;
            
      
            var htmlCode = '<div class="row msg_container base_sent">';
            htmlCode += '<div class="col-md-10 col-xs-10 ">';
            htmlCode += '<div class="messages msg_sent">';
            htmlCode += '<p>'+text+'</p>';
            htmlCode += '<time datetime="2009-11-13T20:00">Timothy • 51 min</time>';
            htmlCode += '</div></div>';
            htmlCode += '<div class="col-md-2 col-xs-2 avatar">';
            htmlCode += '<img src="http://www.bitrebels.com/wp-content/uploads/2011/02/Original-Facebook-Geek-Profile-Avatar-1.jpg" class=" img-responsive ">';
            htmlCode += '</div></div>';
            
            
            
            $('.msg_container_base').append(htmlCode);
            
            $('.msg_container_base').scrollTop($('.msg_container_base')[0].scrollHeight);
            $('#btn-input').val('');
        }
    </script>
</body>
</html>
