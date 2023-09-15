<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.*"%>
<%@page import="web.tkt.tktc.controller.*"%>
<%@page import="web.tkt.tktc.entity.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
<head>
	<title>Booking - Multipurpose Online Booking Theme</title>

	<!-- Meta Tags -->
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="author" content="Webestica.com">
	<meta name="description" content="Booking - Multipurpose Online Booking Theme">

	<!-- Dark mode -->
	<script>
		const storedTheme = localStorage.getItem('theme')
 
		const getPreferredTheme = () => {
			if (storedTheme) {
				return storedTheme
			}
			return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
		}

		const setTheme = function (theme) {
			if (theme === 'auto' && window.matchMedia('(prefers-color-scheme: dark)').matches) {
				document.documentElement.setAttribute('data-bs-theme', 'dark')
			} else {
				document.documentElement.setAttribute('data-bs-theme', theme)
			}
		}

		setTheme(getPreferredTheme())

		window.addEventListener('DOMContentLoaded', () => {
		    var el = document.querySelector('.theme-icon-active');
			if(el != 'undefined' && el != null) {
				const showActiveTheme = theme => {
				const activeThemeIcon = document.querySelector('.theme-icon-active use')
				const btnToActive = document.querySelector(`[data-bs-theme-value="${theme}"]`)
				const svgOfActiveBtn = btnToActive.querySelector('.mode-switch use').getAttribute('href')

				document.querySelectorAll('[data-bs-theme-value]').forEach(element => {
					element.classList.remove('active')
				})

				btnToActive.classList.add('active')
				activeThemeIcon.setAttribute('href', svgOfActiveBtn)
			}

			window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
				if (storedTheme !== 'light' || storedTheme !== 'dark') {
					setTheme(getPreferredTheme())
				}
			})

			showActiveTheme(getPreferredTheme())

			document.querySelectorAll('[data-bs-theme-value]')
				.forEach(toggle => {
					toggle.addEventListener('click', () => {
						const theme = toggle.getAttribute('data-bs-theme-value')
						localStorage.setItem('theme', theme)
						setTheme(theme)
						showActiveTheme(theme)
					})
				})

			}
		})
		
	</script>

	<!-- Favicon -->
	<link rel="shortcut icon" href="<%=request.getContextPath()%>/front_end/assets/images/favicon.ico">

	<!-- Google Font -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;700&family=Poppins:wght@400;500;700&display=swap">

	<!-- Plugins CSS -->
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/front_end/assets/vendor/font-awesome/css/all.min.css">
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/front_end/assets/vendor/bootstrap-icons/bootstrap-icons.css">
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/front_end/assets/vendor/overlay-scrollbar/css/overlayscrollbars.min.css">
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/front_end/assets/vendor/choices/css/choices.min.css">
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/front_end/assets/vendor/glightbox/css/glightbox.css">

	<!-- Theme CSS -->
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/front_end/assets/css/style.css">

</head>

<body>

<!-- **************** MAIN CONTENT START **************** -->
<main>
	
	<!-- Sidebar START -->
	<nav class="navbar sidebar navbar-expand-xl navbar-light">
		<!-- Navbar brand for xl START -->
		<div class="d-flex align-items-center">
			<a class="navbar-brand" href="<%=request.getContextPath()%>/front_end/index.html">
				<img class="light-mode-item navbar-brand-item" src="<%=request.getContextPath()%>/front_end/assets/images/logo.svg" alt="logo">
				<img class="dark-mode-item navbar-brand-item" src="<%=request.getContextPath()%>/front_end/assets/images/logo-light.svg" alt="logo">
			</a>
		</div>
		<!-- Navbar brand for xl END -->
		
		<div class="offcanvas offcanvas-start flex-row custom-scrollbar h-100" data-bs-backdrop="true" tabindex="-1" id="offcanvasSidebar">
			<div class="offcanvas-body sidebar-content d-flex flex-column pt-4">
	
				<!-- Sidebar menu START -->
				<ul class="navbar-nav flex-column" id="navbar-sidebar">
					
					<!-- Menu item -->
					<li class="nav-item"><a href="admin-dashboard.html" class="nav-link">Dashboard</a></li>
					
					<!-- Title -->
					<li class="nav-item ms-2 my-2">Pages</li>

					<!-- Menu item -->
					<li class="nav-item">
						<a class="nav-link" data-bs-toggle="collapse" href="#collapsebooking" role="button" aria-expanded="true" aria-controls="collapsebooking">
						Bookings
						</a>
						<!-- Submenu -->
						<ul class="nav collapse flex-column show" id="collapsebooking" data-bs-parent="#navbar-sidebar">
							<li class="nav-item"> <a class="nav-link active" href="<%=request.getContextPath()%>/tkt/Order?action=getBackAllOrd">票券訂單管理</a></li>
						</ul>
					</li>
	
					<!-- Menu item -->
					<li class="nav-item">
						<a class="nav-link" data-bs-toggle="collapse" href="#collapseguest" role="button" aria-expanded="false" aria-controls="collapseguest">
						Guests
						</a>
						<!-- Submenu -->
						<ul class="nav collapse flex-column" id="collapseguest" data-bs-parent="#navbar-sidebar">
							<li class="nav-item"> <a class="nav-link" href="admin-guest-list.html">Guest List</a></li>
							<li class="nav-item"> <a class="nav-link" href="admin-guest-detail.html">Guest Detail</a></li>
						</ul>
					</li>

					<!-- Menu item -->
					<li class="nav-item">
						<a class="nav-link" data-bs-toggle="collapse" href="#collapseagent" role="button" aria-expanded="false" aria-controls="collapseagent">
						Agents
						</a>
						<!-- Submenu -->
						<ul class="nav collapse flex-column" id="collapseagent" data-bs-parent="#navbar-sidebar">
							<li class="nav-item"> <a class="nav-link" href="admin-agent-list.html">Agent List</a></li>
							<li class="nav-item"> <a class="nav-link" href="admin-agent-detail.html">Agent Detail</a></li>
						</ul>
					</li>
					
					<!-- Menu item -->
					<li class="nav-item"> <a class="nav-link" href="admin-reviews.html">Reviews</a></li>
	
					<!-- Menu item -->
					<li class="nav-item"> <a class="nav-link" href="admin-earnings.html">Earnings</a></li>
	
					<!-- Menu item -->
					<li class="nav-item"> <a class="nav-link" href="admin-settings.html">Admin Settings</a></li>
	
					<!-- Menu item -->
					<li class="nav-item">
						<a class="nav-link" data-bs-toggle="collapse" href="#collapseauthentication" role="button" aria-expanded="false" aria-controls="collapseauthentication">
							Authentication
						</a>
						<!-- Submenu -->
						<ul class="nav collapse flex-column" id="collapseauthentication" data-bs-parent="#navbar-sidebar">
							<li class="nav-item"> <a class="nav-link" href="<%=request.getContextPath()%>/front_end/sign-up.html">Sign Up</a></li>
							<li class="nav-item"> <a class="nav-link" href="<%=request.getContextPath()%>/front_end/sign-in.html">Sign In</a></li>
							<li class="nav-item"> <a class="nav-link" href="<%=request.getContextPath()%>/front_end/forgot-password.html">Forgot Password</a></li>
							<li class="nav-item"> <a class="nav-link" href="error.html">Error 404</a></li>
						</ul>
					</li>
	
					<!-- Title -->
					<li class="nav-item ms-2 my-2">Documentation</li>
	
					<!-- Menu item -->
					<li class="nav-item"> <a class="nav-link" href="docs/index.html">Documentation</a></li>
	
					<!-- Menu item -->
					<li class="nav-item"> <a class="nav-link" href="docs/changelog.html">Changelog</a></li>
				</ul>
				<!-- Sidebar menu end -->
	
				<!-- Sidebar footer START -->
				<div class="d-flex align-items-center justify-content-between text-primary-hover mt-auto p-3">
					<a class="h6 fw-light mb-0 text-body" href="<%=request.getContextPath()%>/front_end/sign-in.html" data-bs-toggle="tooltip" data-bs-placement="top" aria-label="Sign out">
						<i class="fa-solid fa-arrow-right-from-bracket"></i> Log out
					</a>
					<a class="h6 mb-0 text-body" href="admin-settings.html" data-bs-toggle="tooltip" data-bs-placement="top" aria-label="Settings">
						<i class="bi bi-gear-fill"></i>
					</a>
				</div>
				<!-- Sidebar footer END -->
				
			</div>
		</div>
	</nav>
	<!-- Sidebar END -->
	
	<!-- Page content START -->
	<div class="page-content">
	
		<!-- Top bar START -->
		<nav class="navbar top-bar navbar-light py-0 py-xl-3">
			<div class="container-fluid p-0">
				<div class="d-flex align-items-center w-100">
	
					<!-- Logo START -->
					<div class="d-flex align-items-center d-xl-none">
						<a class="navbar-brand" href="<%=request.getContextPath()%>/front_end/index.html">
							<img class="navbar-brand-item h-40px" src="<%=request.getContextPath()%>/front_end/assets/images/logo-icon.svg" alt="">
						</a>
					</div>
					<!-- Logo END -->
	
					<!-- Toggler for sidebar START -->
					<div class="navbar-expand-xl sidebar-offcanvas-menu">
						<button class="navbar-toggler me-auto p-2" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasSidebar" aria-controls="offcanvasSidebar" aria-expanded="false" aria-label="Toggle navigation" data-bs-auto-close="outside">
							<i class="bi bi-list text-primary fa-fw" data-bs-target="#offcanvasMenu"></i>
						</button>
					</div>
					<!-- Toggler for sidebar END -->
					
					<!-- Top bar left -->
					<div class="navbar-expand-lg ms-auto ms-xl-0">
						<!-- Toggler for menubar START -->
						<button class="navbar-toggler ms-auto p-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarTopContent" aria-controls="navbarTopContent" aria-expanded="false" aria-label="Toggle navigation">
							<i class="bi bi-search"></i>
						</button>
						<!-- Toggler for menubar END -->
	
						<!-- Topbar menu START -->
						<div class="collapse navbar-collapse w-100 z-index-1" id="navbarTopContent">
							<!-- Top search START -->
							<div class="nav my-3 my-xl-0 flex-nowrap align-items-center">
								<div class="nav-item w-100">
									<form class="position-relative">
										<input class="form-control bg-light pe-5" type="search" placeholder="Search" aria-label="Search">
										<button class="bg-transparent px-2 py-0 border-0 position-absolute top-50 end-0 translate-middle-y" type="submit"><i class="fas fa-search fs-6 text-primary"></i></button>
									</form>
								</div>
							</div>
							<!-- Top search END -->
						</div>
						<!-- Topbar menu END -->
					</div>
					<!-- Top bar left END -->
					
					<!-- Top bar right START -->
					<ul class="nav flex-row align-items-center list-unstyled ms-xl-auto">
						<!-- Dark mode options START -->
						<li class="nav-item dropdown ms-3">
							<button class="nav-notification lh-0 btn btn-light p-0 mb-0" id="bd-theme"
							type="button"
							aria-expanded="false"
							data-bs-toggle="dropdown"
							data-bs-display="static">
								<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-circle-half fa-fw theme-icon-active" viewBox="0 0 16 16">
									<path d="M8 15A7 7 0 1 0 8 1v14zm0 1A8 8 0 1 1 8 0a8 8 0 0 1 0 16z"/>
									<use href="#"></use>
								</svg>
							</button>

							<ul class="dropdown-menu min-w-auto dropdown-menu-end" aria-labelledby="bd-theme">
								<li class="mb-1">
									<button type="button" class="dropdown-item d-flex align-items-center" data-bs-theme-value="light">
										<svg width="16" height="16" fill="currentColor" class="bi bi-brightness-high-fill fa-fw mode-switch me-1" viewBox="0 0 16 16">
											<path d="M12 8a4 4 0 1 1-8 0 4 4 0 0 1 8 0zM8 0a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 0zm0 13a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 13zm8-5a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1h2a.5.5 0 0 1 .5.5zM3 8a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1h2A.5.5 0 0 1 3 8zm10.657-5.657a.5.5 0 0 1 0 .707l-1.414 1.415a.5.5 0 1 1-.707-.708l1.414-1.414a.5.5 0 0 1 .707 0zm-9.193 9.193a.5.5 0 0 1 0 .707L3.05 13.657a.5.5 0 0 1-.707-.707l1.414-1.414a.5.5 0 0 1 .707 0zm9.193 2.121a.5.5 0 0 1-.707 0l-1.414-1.414a.5.5 0 0 1 .707-.707l1.414 1.414a.5.5 0 0 1 0 .707zM4.464 4.465a.5.5 0 0 1-.707 0L2.343 3.05a.5.5 0 1 1 .707-.707l1.414 1.414a.5.5 0 0 1 0 .708z"/>
											<use href="#"></use>
										</svg>Light						
									</button>
								</li>
								<li class="mb-1">
									<button type="button" class="dropdown-item d-flex align-items-center" data-bs-theme-value="dark">
										<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-moon-stars-fill fa-fw mode-switch me-1" viewBox="0 0 16 16">
											<path d="M6 .278a.768.768 0 0 1 .08.858 7.208 7.208 0 0 0-.878 3.46c0 4.021 3.278 7.277 7.318 7.277.527 0 1.04-.055 1.533-.16a.787.787 0 0 1 .81.316.733.733 0 0 1-.031.893A8.349 8.349 0 0 1 8.344 16C3.734 16 0 12.286 0 7.71 0 4.266 2.114 1.312 5.124.06A.752.752 0 0 1 6 .278z"/>
											<path d="M10.794 3.148a.217.217 0 0 1 .412 0l.387 1.162c.173.518.579.924 1.097 1.097l1.162.387a.217.217 0 0 1 0 .412l-1.162.387a1.734 1.734 0 0 0-1.097 1.097l-.387 1.162a.217.217 0 0 1-.412 0l-.387-1.162A1.734 1.734 0 0 0 9.31 6.593l-1.162-.387a.217.217 0 0 1 0-.412l1.162-.387a1.734 1.734 0 0 0 1.097-1.097l.387-1.162zM13.863.099a.145.145 0 0 1 .274 0l.258.774c.115.346.386.617.732.732l.774.258a.145.145 0 0 1 0 .274l-.774.258a1.156 1.156 0 0 0-.732.732l-.258.774a.145.145 0 0 1-.274 0l-.258-.774a1.156 1.156 0 0 0-.732-.732l-.774-.258a.145.145 0 0 1 0-.274l.774-.258c.346-.115.617-.386.732-.732L13.863.1z"/>
											<use href="#"></use>
										</svg>Dark
									</button>
								</li>
								<li>
									<button type="button" class="dropdown-item d-flex align-items-center active" data-bs-theme-value="auto">
										<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-circle-half fa-fw mode-switch" viewBox="0 0 16 16">
											<path d="M8 15A7 7 0 1 0 8 1v14zm0 1A8 8 0 1 1 8 0a8 8 0 0 1 0 16z"/>
											<use href="#"></use>
										</svg>Auto
									</button>
								</li>
							</ul>
						</li>
						<!-- Dark mode options END-->

						<!-- Notification dropdown START -->
						<li class="nav-item dropdown ms-3">
							<!-- Notification button -->
							<a class="nav-notification btn btn-light p-0 mb-0" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false" data-bs-auto-close="outside">
								<i class="bi bi-bell fa-fw"></i>
							</a>
							<!-- Notification dote -->
							<span class="notif-badge animation-blink"></span>
		
							<!-- Notification dropdown menu START -->
							<div class="dropdown-menu dropdown-animation dropdown-menu-end dropdown-menu-size-md shadow-lg p-0">
								<div class="card bg-transparent">
									<!-- Card header -->
									<div class="card-header bg-transparent d-flex justify-content-between align-items-center border-bottom">
										<h6 class="m-0">Notifications <span class="badge bg-danger bg-opacity-10 text-danger ms-2">4 new</span></h6>
										<a class="small" href="#">Clear all</a>
									</div>
		
									<!-- Card body START -->
									<div class="card-body p-0">
										<ul class="list-group list-group-flush list-unstyled p-2">
											<!-- Notification item -->
											<li>
												<a href="#" class="list-group-item list-group-item-action rounded notif-unread border-0 mb-1 p-3">
													<h6 class="mb-2">New! Booking flights from New York ✈️</h6>
													<p class="mb-0 small">Find the flexible ticket on flights around the world. Start searching today</p>
													<span>Wednesday</span>
												</a>
											</li>
											<!-- Notification item -->
											<li>
												<a href="#" class="list-group-item list-group-item-action rounded border-0 mb-1 p-3">
													<h6 class="mb-2">Sunshine saving are here 🌞 save 30% or more on a stay</h6>
													<span>15 Nov 2022</span>
												</a>
											</li>
										</ul>
									</div>
									<!-- Card body END -->
		
									<!-- Card footer -->
									<div class="card-footer bg-transparent text-center border-top">
										<a href="#" class="btn btn-sm btn-link mb-0 p-0">See all incoming activity</a>
									</div>
								</div>
							</div>
							<!-- Notification dropdown menu END -->
						</li>
						<!-- Notification dropdown END -->
		
						<!-- Profile dropdown START -->
						<li class="nav-item ms-3 dropdown">
							<!-- Avatar -->
							<a class="avatar avatar-sm p-0" href="#" id="profileDropdown" role="button" data-bs-auto-close="outside" data-bs-display="static" data-bs-toggle="dropdown" aria-expanded="false">
								<img class="avatar-img rounded-2" src="<%=request.getContextPath()%>/front_end/assets/images/avatar/01.jpg" alt="avatar">
							</a>
		
							<ul class="dropdown-menu dropdown-animation dropdown-menu-end shadow pt-3" aria-labelledby="profileDropdown">
								<!-- Profile info -->
								<li class="px-3 mb-3">
									<div class="d-flex align-items-center">
										<!-- Avatar -->
										<div class="avatar me-3">
											<img class="avatar-img rounded-circle shadow" src="<%=request.getContextPath()%>/front_end/assets/images/avatar/01.jpg" alt="avatar">
										</div>
										<div>
											<a class="h6 mt-2 mt-sm-0" href="#">Lori Ferguson</a>
											<p class="small m-0">example@gmail.com</p>
										</div>
									</div>
								</li>
		
								<!-- Links -->
								<li> <hr class="dropdown-divider"></li>
								<li><a class="dropdown-item" href="#"><i class="bi bi-bookmark-check fa-fw me-2"></i>My Bookings</a></li>
								<li><a class="dropdown-item" href="#"><i class="bi bi-heart fa-fw me-2"></i>My Wishlist</a></li>
								<li><a class="dropdown-item" href="#"><i class="bi bi-gear fa-fw me-2"></i>Settings</a></li>
								<li><a class="dropdown-item" href="#"><i class="bi bi-info-circle fa-fw me-2"></i>Help Center</a></li>
								<li><a class="dropdown-item bg-danger-soft-hover" href="#"><i class="bi bi-power fa-fw me-2"></i>Sign Out</a></li>
							</ul>
						</li>
						<!-- Profile dropdown END -->
					</ul>
					<!-- Top bar right END -->
				</div>
			</div>
		</nav>
		<!-- Top bar END -->
	
		<!-- Page main content START -->
		<div class="page-content-wrapper p-xxl-4">

			<!-- Booking table START -->
			<div class="card shadow mt-3">
				<!-- Card header START -->
				<div class="card-header border-bottom">
					<h5 class="card-header-title">票券訂單管理</h5>
				</div>
				<!-- Card header END -->

				<!-- Card body START -->
				<div class="card-body">
					<!-- Search and select START -->
					<div class="row g-3 align-items-center justify-content-between mb-3">
						<!-- Search -->
						<div class="col-md-8">
							<form class="rounded position-relative">
								<input class="form-control pe-5" type="search" placeholder="請輸入訂單編號，例:BS-1" aria-label="Search" id="searchOrdNo">
								<button class="btn border-0 px-3 py-0 position-absolute top-50 end-0 translate-middle-y" type="button" id="searchAll"><i class="fas fa-search fs-6"></i></button>
							</form>
						</div>

						<!-- Select option -->
						<div class="col-md-3">
							<!-- Short by filter -->
							<FORM id="orderBy" METHOD="post" ACTION="<%=request.getContextPath()%>/tkt/Order">
							<input type="hidden" name="action" value="getBackAllOrd">
								<select class="form-select js-choice" aria-label=".form-select-sm" name="orderByAll" id="orderByAll">
									<option value="">Sort by</option>
									<option value="1">最新</option>
									<option value="2">最舊</option>
								</select>
							</FORM>
						</div>
					</div>
					<!-- Search and select END -->

					<!-- Table head -->
					<div class="bg-light rounded p-3 d-none d-lg-block">
						<div class="row row-cols-7 g-4">
							<div class="col"><h6 class="mb-0">訂購會員</h6></div>
							<div class="col"><h6 class="mb-0">會員編號</h6></div>
							<div class="col"><h6 class="mb-0">訂單編號</h6></div>
							<div class="col"><h6 class="mb-0">下訂日期</h6></div>
							<div class="col"><h6 class="mb-0">實付金額</h6></div>
							<div class="col"><h6 class="mb-0">訂單狀態</h6></div>
							<div class="col"><h6 class="mb-0">訂單明細</h6></div>
						</div>
					</div>
					<div style="display: none;">
					<%=i = 0%>
					</div>
					<c:forEach var="tktOrd" items="${tktOrdList}">
					<%!int i = 0; %>
					<!-- Table data -->
					<div class="row row-cols-xl-7 align-items-lg-center border-bottom g-4 px-2 py-4 ordItem">
						<!-- Data item -->
						<div class="col">
							<small class="d-block d-lg-none">訂購會員</small>
							<div class="d-flex align-items-center">
								<!-- Avatar -->
								<div class="avatar avatar-xs flex-shrink-0">
									<img class="avatar-img rounded-circle" src="${tktOrd.showPic}" alt="">
								</div>
								<!-- Info -->
								<div class="ms-2">
									<h6 class="mb-0 fw-light">${tktOrd.memName}</h6>
								</div>
							</div>
						</div>	

						<!-- Data item -->
						<div class="col">
							<small class="d-block d-lg-none">會員編號</small>
							<h6 class="mb-0 fw-normal ms-4" id="memNo<%=i%>">${tktOrd.memNo}</h6>
						</div>

						<!-- Data item -->
						<div class="col">
							<small class="d-block d-lg-none">訂單編號</small>
							<h6 class="mb-0 fw-normal ms-2 ordNo" id="ordNo<%=i++%>">BS-${tktOrd.tktOrdNo}</h6>
						</div>

						<!-- Data item -->
						<div class="col">
							<small class="d-block d-lg-none">下訂日期</small>
							<h6 class="mb-0 fw-normal"><fmt:formatDate pattern="yyyy-MM-dd" value="${tktOrd.ordDate}" /></h6>
						</div>

						<!-- Data item -->
						<div class="col">
							<small class="d-block d-lg-none">實付金額</small>
							<h6 class="text-success mb-0 ms-2">$ ${tktOrd.payPrice}</h6>
						</div>
						
						<!-- Data item -->
						<div class="col">
							<small class="d-block d-lg-none">訂單狀態</small>
							<c:choose>
					            <c:when test="${tktOrd.ordStat eq 0}">
					            <div class="badge bg-success bg-opacity-10 text-success ms-1">
					                已付款
					            </div>
					            </c:when>
					            <c:when test="${tktOrd.ordStat eq 1}">
					            <div class="badge bg-warning bg-opacity-10 text-warning ms-1">
					                處理中
					            </div>
					            </c:when>
					            <c:when test="${tktOrd.ordStat eq 2}">
					            <div class="badge bg-danger bg-opacity-10 text-danger ms-1">
					                已退款
					            </div>
					            </c:when>
					        </c:choose>
						</div>

						<!-- Data item -->
						<div class="col">
						<a href="<%=request.getContextPath()%>/tkt/Order?action=getBackOrdDetails&tktOrdNo=${tktOrd.tktOrdNo}" class="btn btn-sm btn-light mb-0 ms-1">
						View</a>
						</div>
					</div>
					</c:forEach>
					<input type="hidden" id="ordList" value="<%=i%>">
				</div>
				<!-- Card body END -->

				<!-- Card footer START -->
				<div class="card-footer pt-0">
					<!-- Pagination and content -->
					<div class="d-sm-flex justify-content-sm-between align-items-sm-center">
						<!-- Content -->
						<p class="mb-sm-0 text-center text-sm-start">Showing 1 to 8 of 20 entries</p>
						<!-- Pagination -->
						<nav class="mb-sm-0 d-flex justify-content-center" aria-label="navigation">
							<ul class="pagination pagination-sm pagination-primary-soft mb-0">
								<li class="page-item disabled">
									<a class="page-link" href="#" tabindex="-1">Prev</a>
								</li>
								<li class="page-item"><a class="page-link" href="#">1</a></li>
								<li class="page-item active"><a class="page-link" href="#">2</a></li>
								<li class="page-item disabled"><a class="page-link" href="#">..</a></li>
								<li class="page-item"><a class="page-link" href="#">15</a></li>
								<li class="page-item">
									<a class="page-link" href="#">Next</a>
								</li>
							</ul>
						</nav>
					</div>
				</div>
				<!-- Card footer END -->
			</div>
			<!-- Booking table END -->

		</div>
		<!-- Page main content END -->
	</div>
	<!-- Page content END -->
	
	</main>
<!-- **************** MAIN CONTENT END **************** -->

<!-- Bootstrap JS -->
<script src="<%=request.getContextPath()%>/front_end/assets/vendor/bootstrap/dist/js/bootstrap.bundle.min.js"></script>

<!-- Vendor -->
<script src="<%=request.getContextPath()%>/front_end/assets/vendor/overlay-scrollbar/js/overlayscrollbars.min.js"></script>
<script src="<%=request.getContextPath()%>/front_end/assets/vendor/choices/js/choices.min.js"></script>
<script src="<%=request.getContextPath()%>/front_end/assets/vendor/glightbox/js/glightbox.js"></script>

<!-- ThemeFunctions -->
<script src="<%=request.getContextPath()%>/front_end/assets/js/functions.js"></script>

<script>

	const searchOrdNo = document.getElementById("searchOrdNo");
	const ordNoList = document.getElementsByClassName("ordNo");
	const searchAll = document.getElementById("searchAll");
	const ordItem = document.getElementsByClassName("ordItem");
	
	searchAll.addEventListener("click", function(){
		
		for(let j = 0; j < ordNoList.length; j++){
			ordItem[j].style="display:flex;";
			if(ordNoList[j].textContent !== searchOrdNo.value.trim() && searchOrdNo.value.trim() !== ""){
				ordItem[j].style="display:none;";
			}
		}
	});
	
	const orderByAll = document.getElementById("orderByAll");
	const orderBy = document.getElementById("orderBy");
	
	orderByAll.addEventListener("change", function(){
		orderBy.submit();
	});
	
</script>

</body>
</html>