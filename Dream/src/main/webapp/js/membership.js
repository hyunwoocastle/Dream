function getContextPath(){
  let hostIndex = location.href.indexOf(location.host) + location.host.length;
  let contextPath = location.href.substring(hostIndex, location.href.indexOf('/',hostIndex+1));
  return contextPath;
}


$(document).ready(function() {
	// 현재 날짜 구하기 시작
	let today = new Date();
	let year = today.getFullYear(); // 년도
	let month = today.getMonth() + 2;  // 월
	let date = today.getDate();  // 날짜

	$("span#membership_year").text(year);
	$("span#membership_month").text(month);
	$("span#membership_date").text(date);
	// 현재 날짜 구하기 끝	


	$(document).on("click", "button#regist", function() {
		// alert("가입하기 버튼 클릭됨");
		$.ajax({
			url: getContextPath()+"/member/membershipRegist.dream",
			data: { "userid": 1 }, // data 는 /MyMVC/member/idDuplicateCheck.up 로 전송해야할 데이터를 말한다.
			type: "post",     // type 을 생략하면 type:"get" 이다.
			dataType: "json",
			async: true,      // async:true 가 비동기 방식을 말한다. async 을 생략하면 기본값이 비동기 방식인 async:true 이다.
			// async:false 가 동기 방식이다. 지도를 할때는 반드시 동기방식인 async:false 을 사용해야만 지도가 올바르게 나온다.  
			success: function(json) {
				// console.log(json.b_membership);
				if (json.b_membership) {
					// alert("이미 멤버십 가입중인 회원입니다.");
					toastr["warning"]("이미 멤버십 가입중인 회원입니다.");
				}
				else {
					// alert("멤버십 가입에 성공했습니다.");
					toastr["success"]("멤버십 가입에 성공했습니다.");
				}
			},

			error: function(request, status, error) {
				// alert("에러발생 페이지로 이동");
				toastr["error"]("에러발생 페이지로 이동");
				location.href=getContextPath()+"/index.dream"
			}

		});
	});
});