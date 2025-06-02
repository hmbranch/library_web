<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 - 도서관 자리예약</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
</head>
<body>
    <div class="login-container">
        <div class="login-box">
            <div class="logo">📝</div>
            <h2>회원가입</h2>
            <p class="subtitle">도서관 자리예약 시스템</p>
            
            <!-- 에러 메시지 -->
            <c:if test="${error != null}">
                <div class="error-message">
                    ${error}
                </div>
            </c:if>
            
            <form action="/library/register" method="post" class="login-form">
                <div class="form-group">
                    <label for="userId">아이디</label>
                    <input type="text" id="userId" name="userId" required 
                           placeholder="사용할 아이디를 입력하세요" 
                           pattern="[a-zA-Z0-9]{4,20}" 
                           title="아이디는 4-20자의 영문, 숫자만 사용 가능합니다">
                </div>
                
                <div class="form-group">
                    <label for="userPw">비밀번호</label>
                    <input type="password" id="userPw" name="userPw" required 
                           placeholder="비밀번호를 입력하세요"
                           minlength="4"
                           title="비밀번호는 최소 4자 이상이어야 합니다">
                </div>
                
                <div class="form-group">
                    <label for="confirmPw">비밀번호 확인</label>
                    <input type="password" id="confirmPw" name="confirmPw" required 
                           placeholder="비밀번호를 다시 입력하세요">
                </div>
                
                <div class="form-group">
                    <label for="name">이름</label>
                    <input type="text" id="name" name="name" required 
                           placeholder="이름을 입력하세요"
                           maxlength="20">
                </div>
                
                <button type="submit" class="login-btn">회원가입</button>
            </form>
            
            <div class="links">
                <a href="/library/login">이미 계정이 있으신가요? 로그인</a>
            </div>
            
            <div class="back-home">
                <a href="/library">← 홈으로 돌아가기</a>
            </div>
        </div>
    </div>
    
    <script>
        // 비밀번호 확인 검증
        document.querySelector('.login-form').addEventListener('submit', function(e) {
            const password = document.getElementById('userPw').value;
            const confirmPassword = document.getElementById('confirmPw').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('비밀번호가 일치하지 않습니다.');
                return false;
            }
        });
    </script>
</body>
</html>