<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .chat-box {
        height: 350px;
        overflow-y: auto;
        border: 1px solid #ddd;
        border-radius: 5px;
        padding: 15px;
        margin-bottom: 15px;
        background-color: #f9f9f9;
    }
    .chat-box h4 {
        font-size: 0.9rem;
        margin: 0 0 10px 0;
        padding-bottom: 10px;
        border-bottom: 1px solid #eee;
    }
    .chat-box h4:last-child {
        border-bottom: none;
    }
    .tab-content {
        padding-top: 20px;
    }
    #to.chat-box {
        display: flex;
        flex-direction: column;
        background-color: #e5ddd5;
    }
    .message-bubble {
        padding: 8px 12px;
        border-radius: 12px;
        margin-bottom: 8px;
        max-width: 70%;
        line-height: 1.4;
        word-wrap: break-word;
    }
    .msg-sent {
        align-self: flex-end;
        background-color: #dcf8c6;
        color: #303030;
    }
    .msg-received {
        align-self: flex-start;
        background-color: #ffffff;
        color: #303030;
    }
</style>

<script>
    let chat1 = {
        url:'',
        stompClient:null,
        init:function(){
            this.id = $('#user_id').text().trim();
            if (!this.id) { this.id = 'guest' + Math.floor(Math.random() * 1000); $('#user_id').text(this.id); }

            $('#connect').click(()=>{
                this.connect();
            });
            $('#disconnect').click(()=>{
                this.disconnect();
            });
            $('#sendall').click(()=>{
                let msg = JSON.stringify({
                    'sendid' : this.id,
                    'content1' : $("#alltext").val()
                });
                this.stompClient.send("/receiveall", {}, msg);
                $("#alltext").val('');
            });
            $('#sendme').click(()=>{
                let msg = JSON.stringify({
                    'sendid' : this.id,
                    'content1' : $("#metext").val()
                });
                this.stompClient.send("/receiveme", {}, msg);
                $("#metext").val('');
            });
            $('#sendto').click(()=>{
                let totext = $('#totext').val();
                let target = $('#target').val();
                if (totext.trim() === '' || target.trim() === '') return;

                var msg = JSON.stringify({
                    'sendid' : this.id,
                    'receiveid' : target,
                    'content1' : totext
                });
                this.stompClient.send('/receiveto', {}, msg);

                let sentHtml = '<div class="message-bubble msg-sent">' + totext + '</div>';
                $("#to").append(sentHtml);
                $("#to").scrollTop($("#to")[0].scrollHeight);

                $('#totext').val('');
            });
        },
        connect:function(){
            let sid = this.id;
            let socket = new SockJS('${websocketurl}chat');
            this.stompClient = Stomp.over(socket);
            
            this.stompClient.connect({}, (frame) => {
                this.setConnected(true);
                console.log('Connected: ' + frame);

                this.stompClient.subscribe('/send', function(msg) {
                    $("#all").prepend(
                        "<h4>" + JSON.parse(msg.body).sendid +": "+
                        JSON.parse(msg.body).content1
                        + "</h4>");
                });
                this.stompClient.subscribe('/send/'+sid, function(msg) {
                    $("#me").prepend(
                        "<h4>" + JSON.parse(msg.body).sendid +": "+
                        JSON.parse(msg.body).content1+ "</h4>");
                });
                this.stompClient.subscribe('/send/to/'+sid, function(msg) {
                    let messageBody = JSON.parse(msg.body);
                    let receivedHtml = '<div class="message-bubble msg-received"><strong>' + messageBody.sendid + ':</strong><br>' + messageBody.content1 + '</div>';
                    $("#to").append(receivedHtml);
                    $("#to").scrollTop($("#to")[0].scrollHeight);
                });
            });
        },
        disconnect:function(){
            if (this.stompClient !== null) {
                this.stompClient.disconnect();
            }
            this.setConnected(false);
            console.log("Disconnected");
        },
        setConnected:function(connected){
            if (connected) {
                $("#status").text("Connected");
            } else {
                $("#status").text("Disconnected");
            }
        }
    }
    $(()=>{
        chat1.init();
    });
</script>

<div class="col-sm-10">
    <h2>Chat1 Page</h2>
    <hr>
    <div class="row">
        <div class="col-sm-3">
            <h4>User: <span id="user_id">${sessionScope.cust.custId}</span></h4>
            <h5>Status: <span id="status">Disconnected</span></h5>
            <hr>
            <button id="connect" class="btn btn-success btn-block">Connect</button>
            <button id="disconnect" class="btn btn-danger btn-block">Disconnect</button>
        </div>
        <div class="col-sm-9">
            <ul class="nav nav-tabs">
                <li class="nav-item">
                    <a class="nav-link active" data-toggle="tab" href="#all_tab">All</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-toggle="tab" href="#me_tab">Me</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-toggle="tab" href="#to_tab">To</a>
                </li>
            </ul>

            <div class="tab-content">
                <div class="tab-pane active container" id="all_tab">
                    <div class="input-group mb-3">
                        <input type="text" id="alltext" class="form-control" placeholder="Message to All">
                        <div class="input-group-append">
                            <button id="sendall" class="btn btn-primary">Send</button>
                        </div>
                    </div>
                    <div id="all" class="chat-box"></div>
                </div>

                <div class="tab-pane container" id="me_tab">
                    <div class="input-group mb-3">
                        <input type="text" id="metext" class="form-control" placeholder="Message to Me">
                        <div class="input-group-append">
                            <button id="sendme" class="btn btn-info">Send</button>
                        </div>
                    </div>
                    <div id="me" class="chat-box"></div>
                </div>

                <div class="tab-pane container" id="to_tab">
                    <div class="input-group mb-3">
                        <input type="text" id="target" class="form-control" placeholder="Target ID">
                        <input type="text" id="totext" class="form-control" placeholder="Private Message">
                        <div class="input-group-append">
                            <button id="sendto" class="btn btn-warning">Send</button>
                        </div>
                    </div>
                    <div id="to" class="chat-box"></div>
                </div>
            </div>
        </div>
    </div>
</div>
