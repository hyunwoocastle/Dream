package choi.admin.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;

public class MemberDetail extends AbstractController{

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String method = request.getMethod(); 
		
		if("GET".equalsIgnoreCase(method)) { // method가 "GET"일 때 
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/view/admin/ad_member/memberDetail.jsp");
		}
		else {	// method가 "POST"일 때 
			
		}
		
	}

}