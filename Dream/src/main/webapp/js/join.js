// js파일에서 contextPath를 알아내는 함수
function getContextPath(){
  let hostIndex = location.href.indexOf(location.host) + location.host.length;
  let contextPath = location.href.substring(hostIndex, location.href.indexOf('/',hostIndex+1));
  return contextPath;
}


$(document).ready(function(){
      $("button#btn_join").attr("disabled",true);
      $("button#btn_join").css("background","#EBEBEB");
      
      // 변수 선언
      const input_userid = $("input:text[name='userid']");
      const input_passwd = $("input:password[name='passwd']");
      const input_passwd_check = $("input:password[name='passwd_check']");
      
      let id_ok = false;
      let passwd_ok = false;
      let passwd_check_ok = false;
      
	  
      input_userid.focus();


	  // 숫자/문자/특수문자 포함 형태의 8 ~ 15자리 이내의 암호 정규 표현식
      // const regExp = new RegExp(/^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g);

      //아이디 인풋박스에 값을 입력시
      input_userid.keyup(function(){
		let userid = input_userid.val().trim(); //사용자가 입력한 유저아이디 값
		
		if(userid==""){
		  $("p#userid_error").css("display","block");	//공백에러메시지 나타내기
		  $("p#userid_error").html("아이디는 필수정보 입니다.");
		  input_userid.css("border-bottom","solid 1px red");  //빨간색 밑줄
		  $("label[for='userid']").css("color","red");  //라벨 빨간색
		  id_ok = false;
		  agree_check();
		  return;
		}
		else{	//사용자가 입력한 유저아이디 값이 공백이 없을경우
		  $("p#userid_error").css("display","none");  //공백에러메시지 감추기
		  input_userid.css("border-bottom",""); //빨간색 밑줄 감추기
		  $("label[for='userid']").css("color",""); // 라벨빨간색 감추기
	      check_userid(userid);	//아이디 형식,중복여부검사함수 호출
		}
		
		
		
      });

      //비밀번호 인풋박스에 값을 입력시
      input_passwd.keyup(function(){
		let passwd = input_passwd.val().trim();  
        check_passwd(passwd);
      });
      //비밀번호확인 인풋박스에 값을 입력시
      input_passwd_check.keyup(function(){  
        passwd_check();
      });//end of input_passwd_check.keydown(function(){})-----
      
      
      //약관 체크박스
      $("input:checkbox[name='agree_age']").change(function(){
		agree_check();	//회원가입 준비 완료인지 아닌지 검사하는 함수 호출
      });
      
      
      //이메일 인증번호 전송을 클릭했을때
      $("button#btn_send_email").click(function(){
		const userid = input_userid.val();
		
		$("input#emailConfirmCode").css("display","inline-block");
		$("span#send_guide").html(`입력하신 이메일 ${userid}로 <br> 인증번호를 전송하였습니다.`);
		
		const frm = document.joinFrm;
		
		
		frm.action = getContextPath()+"/member/emailCheck.dream";
		frm.method = "POST";
		frm.submit();
	  });
	  
	  //가입하기 버튼 클릭시
	  $("button#btn_join").click(function(){
		$("span#send_guide").html("");
	  });
      
      



      // Function Declaration
      
      //사용자가 입력한 아이디를 입력받아서 아이디 형식,체크여부를 검사해주는 함수
      function check_userid(userid){
		const regExp= /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
		if(!(regExp.test(userid)) ){ //아이디 형식에 맞지않게 입력한경우
		  $("input:text[name='userid']").css("border-bottom","solid 1px red");  //빨간색 밑줄
          $("label[for='userid']").css("color","red");  //라벨 빨간색
          $("p#userid_error").css("color","red");
          $("p#userid_error").css("display","block");  //에러문구
          $("p#userid_error").html("아이디는 이메일 형식에 맞게 입력해주세요");  //에러문구
          id_ok = false;
          agree_check();
          return;
		}
		else{	//아이디 형식에 맞게 입력한 경우 중복여부검사하기
		  $.ajax({ 
			url:getContextPath()+"/member/idDuplicateCheck.dream", 
			data:{"userid": userid},
			type:"post",
			dataType:"json",
			success:function(json){
			  if(json.isExists){	// 입력한 아이디가 이미 사용중이라면
			    $("input:text[name='userid']").css("border-bottom","solid 1px red");  //빨간색 밑줄
			    $("label[for='userid']").css("color","red"); //라벨 빨간색
			    $("p#userid_error").css("color","red");
			    $("p#userid_error").css("display","block");
			    $("p#userid_error").html("이미 사용하고 있는 아이디입니다.");
			    id_ok = false;
			    agree_check();
			  }
			  else{	//입력한 아이디가 사용중이 아니라면
				$("input:text[name='userid']").css("border-bottom","");  //빨간색 밑줄
			    $("label[for='userid']").css("color",""); //라벨 빨간색
			    $("p#userid_error").css("display","block");
			    $("p#userid_error").css("color","blue");
			    $("p#userid_error").html("사용할 수 있는 아이디 입니다.");
			    id_ok = true;
			    agree_check();
			  }
			},//end of success
			
			//success 대신 error가 발생하면 실행될 코드 
			error: function(request,status,error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		  });//end of $.ajax({})---
		}//end of else--
      }//end of function check_userid(userid){}---
      
  	  
  	  //사용자가 입력한 비밀번호를 입력받아서 비밀번호 형식을 검사해주는 함수
      function check_passwd(passwd){
		const regExp = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g; 
		if(!(regExp.test(passwd))){
	        input_passwd.css("border-bottom","solid 1px red");  //빨간색 밑줄
	        $("p#passwd_error").css("display","block");  //에러문구
	        $("label[for='passwd']").css("color","red");  //라벨 빨간색
	        passwd_ok = false;
	        agree_check();
        }
        else{
			input_passwd.css("border-bottom","");  //빨간색 밑줄 없애기
	        $("label[for='passwd']").css("color","");  //라벨 빨간색 없애기
	        $("p#passwd_error").css("display","none");  //에러문구 없애기
	        passwd_ok = true;
	        agree_check();
	    }
	  }
      
      
      
      // 비밀번호체크란과 입력한 비밀번호가 같은지 검사하는 함수
      function passwd_check(){
		let passwd = input_passwd.val();  
		let passwd_check = input_passwd_check.val();
	    if(passwd !=passwd_check){
			input_passwd_check.css("border-bottom","solid 1px red");  //빨간색 밑줄 
	        $("label[for='passwd_check']").css("color","red");  //라벨 빨간색 
	        $("p#passwd_check_error").css("display","block");  //에러문구 나타내기
	        passwd_check_ok = false;
	        agree_check();
		}
		else{
			input_passwd_check.css("border-bottom","");  //빨간색 밑줄 없애기
	        $("label[for='passwd_check']").css("color","");  //라벨 빨간색 없애기
	        $("p#passwd_check_error").css("display","none");  //에러문구 없애기
	        passwd_check_ok = true;
	        agree_check();
		}
	  }
	  
	  
	  
	  
	  //체크박스 체크했는지 알아내기
	  function agree_check(){
	  	if(id_ok  && passwd_ok && passwd_check_ok){	//회원가입 입력 조건이 갖춰지면
		  const chkbox_agree_age = $("input:checkbox[name='agree_age']:checked").length
		  	if(chkbox_agree_age == 0){	//이용약관 여부를 검사하고.
				$("button#join").attr("disabled",true);
      			$("button#btn_join").css("background","#EBEBEB");
				return;
			}
			else{	//회원가입 입력 조건이 갖춰지고, 이용약관 동의도 하였다면,
				$("button#btn_join").attr("disabled",false);
      			$("button#btn_join").css("background","");
				return;
			}
		}
		else{	//회원가입 입력 조건이 갖춰지지 않았다면
			$("button#btn_join").attr("disabled",true);
  			$("button#btn_join").css("background","#EBEBEB");
			return;
		}
		  
	  }//end of agree_check
	  
	  
	  
	  
	  //가입하기 버튼 클릭시 이메일인증하기
	  //$("button#btn_join").click(function(e){
		//	const userid = input_userid.val().trim();
		//	const frm = document.joinFrm;
		//	frm.action =getContextPath()+"/member/emailcheck.dream"; // 자기 자신한테 보냄 
		//	frm.method ="POST"; // 대소문자 구분 x (javascript)
	//	frm.submit();
			
	  // });// end of $("button#btnFind").click(function(e)------------------------
	  
	  
	  
		
		
	
    });//end of  $(document).ready(function(){}-----
