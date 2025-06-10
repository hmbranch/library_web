<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 대시보드 - 도서관 관리 시스템</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
    <style>
        /* 모든 애니메이션과 전환 효과 완전 제거 */
        *, *::before, *::after {
            -webkit-animation-duration: 0s !important;
            -webkit-animation-delay: 0s !important;
            -webkit-transition-duration: 0s !important;
            -webkit-transition-delay: 0s !important;
            -moz-animation-duration: 0s !important;
            -moz-animation-delay: 0s !important;
            -moz-transition-duration: 0s !important;
            -moz-transition-delay: 0s !important;
            -o-animation-duration: 0s !important;
            -o-animation-delay: 0s !important;
            -o-transition-duration: 0s !important;
            -o-transition-delay: 0s !important;
            animation-duration: 0s !important;
            animation-delay: 0s !important;
            transition-duration: 0s !important;
            transition-delay: 0s !important;
            animation: none !important;
            transition: none !important;
            transform: none !important;
        }
        
        /* 페이지 전체 애니메이션 제거 */
        html, body, div, section, article, main, header, footer, nav {
            animation: none !important;
            transition: none !important;
            transform: none !important;
            -webkit-animation: none !important;
            -webkit-transition: none !important;
            -webkit-transform: none !important;
        }
        
        /* 컨테이너 관련 애니메이션 제거 */
        .admin-container, .admin-header, .admin-stats-bar, .admin-actions, .seat-management {
            animation: none !important;
            transition: none !important;
            transform: none !important;
            -webkit-animation: none !important;
            -webkit-transition: none !important;
            -webkit-transform: none !important;
        }
        
        /* 특별히 필요한 애니메이션만 다시 활성화 */
        .signal-badge.active {
            background-color: #4CAF50;
            color: white;
            animation: pulse 2s infinite !important;
        }
        
        /* 아두이노 신호 상태 스타일 */
        .signal-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        .signal-badge.inactive {
            background-color: #f44336;
            color: white;
        }
        
        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.5; }
            100% { opacity: 1; }
        }
        
        /* 실시간 업데이트 인디케이터 */
        .update-indicator {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 10px 15px;
            background-color: #2196F3;
            color: white;
            border-radius: 20px;
            font-size: 14px;
            display: none;
            z-index: 1000;
        }
        
        .update-indicator.show {
            display: block;
        }
        
        /* 수동 제어 버튼 */
        .manual-control {
            display: inline-flex;
            gap: 4px;
            margin-left: 8px;
        }
        
        .manual-btn {
            padding: 2px 6px;
            font-size: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        
        .manual-btn.on {
            background-color: #4CAF50;
            color: white;
        }
        
        .manual-btn.off {
            background-color: #f44336;
            color: white;
        }
        
        .manual-btn:hover {
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <div class="admin-header">
        <h1>🔧 관리자 대시보드</h1>
        <div class="admin-info">
            <span>관리자: <strong>${loginAdmin.name}</strong>님</span>
            <a href="/admin/logout" class="admin-logout-btn">로그아웃</a>
        </div>
    </div>
    
    <!-- 실시간 업데이트 인디케이터 -->
    <div id="updateIndicator" class="update-indicator">
        📡 실시간 업데이트 중...
    </div>
    
    <div class="admin-container">
        <!-- 알림 메시지 -->
        <c:if test="${param.success == 'cancelled'}">
            <div class="alert alert-success">
                <span>✅</span>
                좌석 예약이 성공적으로 취소되었습니다.
            </div>
        </c:if>
        
        <c:if test="${param.success == 'cleared'}">
            <div class="alert alert-success">
                <span>✅</span>
                만료된 예약이 성공적으로 정리되었습니다.
            </div>
        </c:if>
        
        <c:if test="${param.error == 'cancel_failed'}">
            <div class="alert alert-error">
                <span>⚠️</span>
                좌석 예약 취소에 실패했습니다.
            </div>
        </c:if>
        
        <!-- 통계 정보 -->
        <div class="admin-stats-bar" id="statsBar">
            <div class="stat-item">
                <span class="stat-label">전체 좌석</span>
                <span class="stat-value total" id="totalSeats">${stats.totalSeats}</span>
            </div>
            <div class="stat-item">
                <span class="stat-label">사용 중</span>
                <span class="stat-value occupied" id="occupiedSeats">${stats.occupiedSeats}</span>
            </div>
            <div class="stat-item">
                <span class="stat-label">이용 가능</span>
                <span class="stat-value available" id="availableSeats">${stats.availableSeats}</span>
            </div>
            <div class="stat-item">
                <span class="stat-label">아두이노 ON</span>
                <span class="stat-value">
                    <c:set var="arduinoOnCount" value="0" />
                    <c:forEach var="seat" items="${seats}">
                        <c:if test="${seat.arduinoSignal}">
                            <c:set var="arduinoOnCount" value="${arduinoOnCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${arduinoOnCount}
                </span>
            </div>
        </div>
        
        <!-- 관리 기능 -->
        <div class="admin-actions">
            <h2>🛠️ 관리 기능</h2>
            <div class="action-buttons">
                <form method="post" action="/admin/clear-expired" style="display: inline;">
                    <button type="submit" class="admin-btn admin-btn-warning" 
                            onclick="return confirm('만료된 예약을 모두 정리하시겠습니까?')">
                        <span class="btn-icon">🧹</span>
                        만료된 예약 정리
                    </button>
                </form>
                
                <button onclick="manualRefresh()" class="admin-btn admin-btn-info">
                    <span class="btn-icon">🔄</span>
                    수동 새로고침
                </button>
                
                <button onclick="toggleAutoRefresh()" class="admin-btn admin-btn-secondary" id="autoRefreshBtn">
                    <span class="btn-icon">⏸️</span>
                    자동새로고침 중지
                </button>
                
                <button onclick="openRecordingLink()" class="admin-btn admin-btn-success">
                    <span class="btn-icon">📹</span>
                    녹화 확인
                </button>
            </div>
        </div>
        
        <!-- 좌석 현황 테이블 -->
        <div class="seat-management">
            <h2>📋 좌석 현황 관리</h2>
            
            <div class="table-container">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>좌석 번호</th>
                            <th>상태</th>
                            <th>예약자</th>
                            <th>예약 시작</th>
                            <th>예약 종료</th>
                            <th>아두이노 신호</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody id="seatTableBody">
                        <c:forEach var="seat" items="${seats}">
                            <tr class="seat-row ${seat.isOccupied ? 'occupied' : 'available'}" data-seat-id="${seat.seatId}">
                                <td class="seat-number">${seat.seatName}</td>
                                <td class="seat-status">
                                    <span class="status-badge ${seat.statusClass}">
                                        ${seat.statusText}
                                    </span>
                                </td>
                                <td class="seat-user">
                                    <c:choose>
                                        <c:when test="${not empty seat.userId}">
                                            ${seat.userId}
                                        </c:when>
                                        <c:otherwise>
                                            -
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="seat-start">
                                    <c:choose>
                                        <c:when test="${not empty seat.reservationStart}">
                                            <fmt:formatDate value="${seat.reservationStart}" pattern="MM-dd HH:mm"/>
                                        </c:when>
                                        <c:otherwise>
                                            -
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="seat-end">
                                    <c:choose>
                                        <c:when test="${not empty seat.reservationEnd}">
                                            <fmt:formatDate value="${seat.reservationEnd}" pattern="MM-dd HH:mm"/>
                                        </c:when>
                                        <c:otherwise>
                                            -
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="seat-signal">
                                    <span class="signal-badge ${seat.arduinoSignal ? 'active' : 'inactive'}">
                                        ${seat.arduinoSignal ? 'ON' : 'OFF'}
                                    </span>
                                </td>
                                <td class="seat-actions">
                                    <c:if test="${seat.isOccupied}">
                                        <form method="post" action="/admin/cancel-seat" style="display: inline;">
                                            <input type="hidden" name="seatId" value="${seat.seatId}">
                                            <button type="submit" class="admin-btn admin-btn-danger admin-btn-sm" 
                                                    onclick="return confirm('좌석 ${seat.seatName} 예약을 취소하시겠습니까?')">
                                                <span class="btn-icon">❌</span>
                                                취소
                                            </button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        
        <!-- 푸터 -->
        <div class="admin-footer">
            <p>📞 시스템 문의: 032-123-4567 | 🕒 관리자 근무시간: 09:00 - 22:00</p>
            <p>🔄 마지막 업데이트: <span id="lastUpdate">-</span></p>
        </div>
    </div>
    
    <script>
        let autoRefreshEnabled = true;
        let refreshInterval;
        
        // 페이지 로드 시 실행
        document.addEventListener('DOMContentLoaded', function() {
            console.log('🚀 관리자 페이지 로드 완료');
            
            // 모든 애니메이션 강제 제거
            removeAllAnimations();
            
            updateLastUpdateTime();
            startAutoRefresh();
        });
        
        // 모든 애니메이션 강제 제거 함수
        function removeAllAnimations() {
            console.log('🚫 모든 애니메이션 제거 중...');
            
            // 모든 요소에서 애니메이션 관련 스타일 제거
            const allElements = document.querySelectorAll('*');
            allElements.forEach(element => {
                element.style.animation = 'none';
                element.style.transition = 'none';
                element.style.transform = 'none';
                element.style.webkitAnimation = 'none';
                element.style.webkitTransition = 'none';
                element.style.webkitTransform = 'none';
            });
            
            // CSS 애니메이션 비활성화 스타일 강제 추가
            const style = document.createElement('style');
            style.innerHTML = `
                * {
                    animation: none !important;
                    transition: none !important;
                    transform: none !important;
                    -webkit-animation: none !important;
                    -webkit-transition: none !important;
                    -webkit-transform: none !important;
                }
                
                /* 아두이노 신호만 예외 */
                .signal-badge.active {
                    animation: pulse 2s infinite !important;
                }
            `;
            document.head.appendChild(style);
            
            console.log('✅ 애니메이션 제거 완료');
        }
        
        // 자동 새로고침 시작 (완전 새로고침 방식)
        function startAutoRefresh() {
            if (refreshInterval) {
                clearInterval(refreshInterval);
                console.log('🔄 기존 인터벌 정리');
            }
            
            console.log('⏰ 자동 완전 새로고침 시작 - 5초마다 페이지 새로고침');
            refreshInterval = setInterval(function() {
                if (autoRefreshEnabled) {
                    console.log('🔄 페이지 완전 새로고침 실행');
                    location.reload(); // 완전 새로고침
                }
            }, 5000); // 5초마다 완전 새로고침
        }
        
        // 녹화 확인 링크 열기
        function openRecordingLink() {
            // 여기에 원하는 링크 URL을 입력하세요
            const recordingUrl = "https://example.com/recording"; // 실제 링크로 변경하세요
            
            console.log('📹 녹화 확인 페이지 열기:', recordingUrl);
            
            // 새창으로 링크 열기
            window.open(recordingUrl, '_blank', 'width=1200,height=800,scrollbars=yes,resizable=yes');
        }
        
        // 수동 새로고침
        function manualRefresh() {
            console.log('🔄 수동 새로고침 실행');
            location.reload();
        }
        
        // 자동 새로고침 토글
        function toggleAutoRefresh() {
            autoRefreshEnabled = !autoRefreshEnabled;
            const btn = document.getElementById('autoRefreshBtn');
            
            if (autoRefreshEnabled) {
                btn.innerHTML = '<span class="btn-icon">⏸️</span> 자동새로고침 중지';
                btn.className = 'admin-btn admin-btn-secondary';
                console.log('▶️ 자동 새로고침 시작');
                startAutoRefresh(); // 다시 시작
            } else {
                btn.innerHTML = '<span class="btn-icon">▶️</span> 자동새로고침 시작';
                btn.className = 'admin-btn admin-btn-success';
                console.log('⏸️ 자동 새로고침 중지');
                if (refreshInterval) {
                    clearInterval(refreshInterval);
                }
            }
        }
        
        // 아두이노 신호 수동 업데이트
        async function manualUpdateArduino(seatId, signal) {
            try {
                const seatIdNum = parseInt(seatId);
                console.log(`🔧 좌석 ${seatIdNum} 아두이노 신호를 ${signal ? 'ON' : 'OFF'}로 수동 변경 시도`);
                
                const response = await fetch('/admin/api/arduino/manual-update', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `seatId=${seatIdNum}&signal=${signal}`
                });
                
                const data = await response.json();
                
                if (data.success) {
                    console.log('✅ 아두이노 신호 수동 업데이트 성공:', data.message);
                    // 즉시 페이지 새로고침
                    setTimeout(() => {
                        location.reload();
                    }, 500);
                } else {
                    console.error('❌ 아두이노 신호 수동 업데이트 실패:', data.message);
                    alert('아두이노 신호 업데이트 실패: ' + data.message);
                }
            } catch (error) {
                console.error('❌ 수동 업데이트 네트워크 오류:', error);
                alert('네트워크 오류가 발생했습니다.');
            }
        }
        
        // 마지막 업데이트 시간 표시
        function updateLastUpdateTime() {
            const now = new Date();
            const timeString = now.toLocaleString('ko-KR');
            document.title = `관리자 대시보드 - ${timeString}`;
            
            // 마지막 업데이트 시간 표시
            const lastUpdateElement = document.getElementById('lastUpdate');
            if (lastUpdateElement) {
                lastUpdateElement.textContent = timeString;
            }
        }
        
        // 페이지 언로드 시 인터벌 정리
        window.addEventListener('beforeunload', function() {
            if (refreshInterval) {
                clearInterval(refreshInterval);
                console.log('🛑 페이지 종료 - 인터벌 정리');
            }
        });
        
        // 페이지 포커스/블러 처리 (탭 전환 시)
        document.addEventListener('visibilitychange', function() {
            if (document.hidden) {
                console.log('🙈 페이지가 백그라운드로 이동 - 자동 새로고침 일시 정지');
                if (refreshInterval) {
                    clearInterval(refreshInterval);
                }
            } else {
                console.log('👀 페이지가 다시 활성화 - 자동 새로고침 재시작');
                if (autoRefreshEnabled) {
                    startAutoRefresh();
                }
            }
        });
    </script>
</body>
</html>