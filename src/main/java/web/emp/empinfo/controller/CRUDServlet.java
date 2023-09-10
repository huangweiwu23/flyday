package web.emp.empinfo.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.lang.reflect.Type;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.core.util.IOUtils;
import org.aspectj.org.eclipse.jdt.internal.compiler.lookup.InvocationSite.EmptyWithAstNode;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import web.emp.empinfo.dao.EmpDao;
import web.emp.empinfo.entity.Emp;
import web.emp.empinfo.service.EmpService;
import web.emp.empinfo.service.impl.EmpServiceImpl;

@WebServlet("/emp/controller")
public class CRUDServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private EmpDao dao;
	private EmpService empService;

	public void init() throws ServletException {
		ApplicationContext applicationContext = WebApplicationContextUtils
				.getWebApplicationContext(getServletContext());
		dao = applicationContext.getBean(EmpDao.class);// 初始化EmpDao，我們的資料託管給Bean
		empService = applicationContext.getBean(EmpService.class); // 初始化EmpService，會使原功能變500(?)
		// 檢查碼
		if (dao == null) {
			System.out.println("dao is null during Servlet initialization!");
		}

		if (empService == null) {
			System.out.println("empService is null during Servlet initialization!");
		}
		// 檢查碼end
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)// 複製自login，指示程式碼do when 接到Post請求
			throws ServletException, IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		try {
			Map<String, String> errorMsgs = new LinkedHashMap<String, String>();
			request.setCharacterEncoding("UTF-8");
			Gson gson = new Gson();
//		String action = request.getParameter("action");  //request.getParameter用於從HttpServletRequest取得資料
			BufferedReader reader = request.getReader();
			Map<String, Object> requestData = gson.fromJson(reader, Map.class); // 將JSON內容解析為Map(黃標:安全疑慮)
			String action = (String) requestData.get("action"); // requestData用於解析JSON資料
			String signUp = (String) requestData.get("signUp"); // 從Map中獲取signUp參數

			// 引導刪除功能進入此方法
			if ("btn-delete".equals(action)) {
				request.setAttribute("errorMsgs", errorMsgs);

				/*************************** 1.接收請求參數 ***************************************/
				Integer empNo = Integer.valueOf((String) requestData.get("empNo"));
				try {
					/*************************** 2.開始刪除資料 ***************************************/
					empService.deleteEmp(empNo);
					/*************************** 3.刪除完成,準備轉交(Send the Success view) ***********/
					response.setContentType("application/json"); // 以Json形式回傳資料
					response.setCharacterEncoding("UTF-8");
					response.getWriter().write("{\"success\": true, \"message\": \"刪除成功\"}"); // 回傳資訊
					return; // 這裡加上 return 確保不會繼續執行下面的程式碼

				} catch (Exception e) {
					response.setContentType("application/json");
					response.setCharacterEncoding("UTF-8");
					response.getWriter().write("{\"success\": false, \"message\": \"刪除時出錯: " + e.getMessage() + "\"}");
					return; // 這裡加上 return 確保不會繼續執行下面的程式碼
				}

			}

			// 新增員工功能
			if ("btn-signUp".equals(signUp)) {
				try {
					// 測試從HttpServletRequest中讀取JSON：
					StringBuilder buffer = new StringBuilder();
					String line;
					while ((line = reader.readLine()) != null) {
						buffer.append(line);
					}
					String jsonContent = buffer.toString();
					System.out.println("Received JSON: " + jsonContent);
					// 測試end,成功新建資料
					Emp emp = gson.fromJson(gson.toJson(requestData), Emp.class);
					if (emp == null) {
						System.out.println("Parsed Emp object is null");
						return;
					}
					emp = empService.register(emp);
					if (emp == null) {
						System.out.println("Emp object after register is null");
						return;
					}
					response.setContentType("application/json");
					try (PrintWriter pw = response.getWriter();) {
						pw.print(gson.toJson(emp));
					}
				} catch (Exception e) {
					e.printStackTrace();
					return;
				}
			}

			// 修改功能
//		try {
			if ("btn-save".equals(action)) {
				// 檢查碼，確認action value
//			System.out.println("Action value: " + action);
				// 檢查碼end
				request.setAttribute("errorMsgs", errorMsgs);

				/*************************** 1.接收請求參數 - 輸入格式的錯誤處理 **********************/
				Integer empNo = null;//先將empNo設為null
				if (requestData.containsKey("empNo")) {
					empNo = Integer.valueOf((String) requestData.get("empNo"));
					//此令empNo轉為String
				}
				
				String empAcc = requestData.containsKey("empAcc") ? (String) requestData.get("empAcc") : null;
				String empPwd = requestData.containsKey("empPwd") ? (String) requestData.get("empPwd") : null;
				String empName = requestData.containsKey("empName") ? (String) requestData.get("empName") : null;
				Integer empStatus = requestData.containsKey("empStatus")
						? Integer.parseInt((String) requestData.get("empStatus"))
						: null;
				//由前端得到修改數據
				Emp update = new Emp();
				update.setEmpNo(empNo);
				update.setEmpAcc(empAcc);
				update.setEmpPwd(empPwd);
				update.setEmpName(empName);
				update.setEmpStatus(empStatus);
				String empAccReg = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";// 判定email
				String empPwdReg = "^[(\u4e00-\u9fa5)(a-zA-Z0-9)]{5,8}$";// 判定5-8碼
				// (\u4e00-\u9fa5):任一Unicode 範圍 4E00 到 9FA5 之間的字符，大致對應到常用的中文字。
				// (a-zA-Z0-9)任一小寫、大寫字母，0-9;{5,8}前述字符出現5-8次

				// 修改信箱、密碼、姓名、在職碼
				if (empAcc == null || empAcc.trim().length() == 0) {
					errorMsgs.put("empAcc", "未輸入員工帳號");
				} else if (!empAcc.trim().matches(empAccReg)) {
					errorMsgs.put("empAcc", "員工帳號:限定聯絡email");
				}
				// =============================================
				if (empPwd == null || empPwd.trim().length() == 0) {
					errorMsgs.put("empPwd", "未輸入密碼");
				} else if (!empPwd.trim().matches(empPwdReg)) {
					errorMsgs.put("empPwd", "密碼:請設置5到8位數密碼");
				}
				// ==============================================
				if (empName == null || empName.trim().length() == 0) {
					errorMsgs.put("empName", "未輸入姓名");
				}

//				String job = request.getParameter("job").trim();
//				String jobReg = "^.{2,10}$"; //此正則(規)表示式(regular-expression)- 用來比對JSR 303 的@Size
//				if (job == null || job.trim().length() == 0) {
//					errorMsgs.put("job","員工職位: 請勿空白");
//				} else if(!job.trim().matches(jobReg)) {
//					errorMsgs.put("job","員工職位: 長度必需在2到10之間");
//	            }

//				java.sql.Date hiredate = null;
//				try {
//					hiredate = java.sql.Date.valueOf(request.getParameter("hiredate").trim());
//				} catch (IllegalArgumentException e) {
//					errorMsgs.put("hiredate","雇用日期: 請勿空白");
//				}

//				Double sal = null;
//				try {
//					sal = Double.valueOf(request.getParameter("sal").trim());
//				} catch (NumberFormatException e) {
//					errorMsgs.put("sal","員工薪水: 請輸入數字");
//				}

//				Double comm = null;
//				try {
//					comm = Double.valueOf(request.getParameter("comm").trim());
//				} catch (NumberFormatException e) {
//					errorMsgs.put("comm","員工獎金: 請輸入數字");
//				}

				// 照片
//				InputStream in = request.getPart("upFiles").getInputStream(); //從javax.servlet.http.Part物件取得上傳檔案的InputStream
//				byte[] upFiles = null;
//				if(in.available()!=0){
//					upFiles = new byte[in.available()];
//					in.read(upFiles);
//					in.close();
//				}  else {
//					EmpService empSvc = new EmpService();
//					upFiles = empSvc.getOneEmp(empno).getUpFiles();
//				}

				// Send the use back to the form, if there were errors
//			if (!errorMsgs.isEmpty()) {
//				errorMsgs.put("Exception", "修改資料失敗:---------------");
//				RequestDispatcher failureView = request.getRequestDispatcher("/back-end/emp/update_emp_input.jsp");
//				failureView.forward(request, response);
//				return; // 程式中斷
//			}
				// Send the use back to the form, if there were errors by json
				if (!errorMsgs.isEmpty()) {
					String jsonErrorMsgs = new Gson().toJson(errorMsgs);
					out.print("{\"success\":false, \"errors\":" + jsonErrorMsgs + "}");
					return; // 程式中斷
				}

				/*************************** 2.開始修改資料 *****************************************/
				if (empService == null) {
					out.print("{\"success\":false, \"message\":\"伺服器錯誤\"}");
					return; // this will exit the doPost method
				}
//			EmpServiceImpl empUpdata = new EmpServiceImpl();
//			Emp emp = empUpdata.update(update);
				Emp emp = empService.update(update);
				//偵錯檢查碼
				if(emp.getEmpNo() == null) {
				    System.out.println("EmpNo is null after update operation.");
				} else {
				    System.out.println("Updating emp with empNo: " + emp.getEmpNo());
				    out.print("{\"success\":true, \"message\":\"修改成功\"}");
				}
				//偵錯檢查碼end
				/*************************** 3.修改完成,準備轉交(Send the Success view) *************/
//			request.setAttribute("success", "- (修改成功)");
//			request.setAttribute("emp", emp); // 資料庫update成功後,正確的的empVO物件,存入req
//			String url = "/back_end/empList.html";
////			request.getRequestDispatcher("/back_end/empList.html").forward(request, response);
//			RequestDispatcher successView = request.getRequestDispatcher(url); // 修改成功後,轉交listOneEmp.jsp
//			successView.forward(request, response);
			}
//	} catch(Exception e) {
//	    out.print("{\"success\":false, \"message\":\"伺服器內部錯誤\"}");
//	    return;
//	}
			// 單一員工查詢功能，無引導機制
			else {
				System.out.println("Action value: " + action);
				System.out.println("查詢員工功能");
				try (BufferedReader br = request.getReader();) {

					Integer empNo = Integer.parseInt(requestData.get("EMP_NO").toString()); // 從 map 中獲取 empNo)
					// 檢查碼
//					Map<String, Object> requestBody = gson.fromJson(br, type);
					//
//					Object empNoObj = requestBody.get("EMP_NO");
//					if (empNoObj == null) {
//					    // 處理這個情況，例如返回一個錯誤信息給前端
//					    response.setContentType("application/json");
//					    response.setCharacterEncoding("UTF-8");
//					    response.getWriter().write("{\"success\": false, \"message\": \"EMP_NO not provided in request.\"}");
//					    return;
//					}
//					Integer empNo = Integer.parseInt(empNoObj.toString());
					// 檢查碼end
					Emp emp = dao.selectByEmpNo(empNo);// 使用 dao 查詢 emp
					if (emp == null) {
						emp = new Emp();
						emp.setMessage("請輸入會員編號");
						emp.setSuccessful(false);
						response.setContentType("application/json");
						try (PrintWriter pw = response.getWriter();) {
							pw.print(gson.toJson(emp));
						}
						return;
					}

					HttpSession session = request.getSession();
					session.setAttribute("emp", emp);

					response.setContentType("application/json");
					try (PrintWriter pw = response.getWriter();) {
						pw.print(gson.toJson(emp));
					}

				}
			}

		} catch (Exception e) {
			out.print("{\"success\":false, \"message\":\"伺服器內部錯誤2\"}");
		}
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)// 複製自login，指示程式碼do when 接到Post請求
			throws ServletException, IOException {

		Map<String, String> errorMsgs = new LinkedHashMap<String, String>();

		try {
			Gson gson = new Gson();
			List<Emp> empList = dao.selectAll(); // 獲取所有員工列表

			// 將員工列表轉換為JSON格式並返回給客戶端
			response.setContentType("application/json");
			try (PrintWriter pw = response.getWriter();) {
				pw.print(gson.toJson(empList));
			}

		} catch (Exception e) {
			e.printStackTrace();
			// 處理錯誤情況
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().print("Error retrieving employee data.");
		}

		if (empService == null) {
			errorMsgs.put("serviceError", "Employee service is not initialized.");
			request.setAttribute("errorMsgs", errorMsgs);
			RequestDispatcher failureView = request.getRequestDispatcher("/errorPage.jsp");
			failureView.forward(request, response);
			return; // 終止後續的操作
		}

	}

}
