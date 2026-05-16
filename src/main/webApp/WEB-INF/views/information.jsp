<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Developers - SkyLine</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/landing.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/information.css"/>

    <style>
        .developer-card { cursor: pointer; transition: all 0.3s ease; }
        .developer-card:hover { transform: translateY(-8px); box-shadow: 0 15px 35px rgba(139, 0, 0, 0.2) !important; }

        .developer-popup {
            display: none;
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.85);
            z-index: 2000;
            align-items: center;
            justify-content: center;
        }
        .popup-content {
            background: white;
            color: #333;
            max-width: 480px;
            width: 92%;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 15px 50px rgba(0,0,0,0.5);
        }
        .popup-photo img {
            width: 100%;
            height: 280px;
            object-fit: cover;
        }
        .popup-info {
            padding: 25px;
            text-align: center;
        }
        .popup-info h2 { margin: 10px 0 5px; color: #8B0000; font-size: 24px; }
        .popup-role { color: #555; font-weight: 600; margin-bottom: 15px; }
        .popup-desc { color: #444; line-height: 1.6; margin-bottom: 20px; }
        .close-btn {
            padding: 12px 30px;
            background: #8B0000;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }
    </style>
</head>
<body>

<!-- HEADER -->
<header class="land-header">
    <div class="land-logo">
        <img src="${pageContext.request.contextPath}/static/images/logo.png" class="land-logo-img" alt="SkyLine"/>
        <span class="land-logo-text"><h1>SkyLine</h1></span>
    </div>
    <nav class="land-nav">
        <a href="${pageContext.request.contextPath}/popular-routes" class="land-nav-link"><h2>Routes</h2></a>
        <a href="${pageContext.request.contextPath}/partner-airlines" class="land-nav-link"><h2>Airlines</h2></a>
        <a href="${pageContext.request.contextPath}/travel-guide" class="land-nav-link"><h2>Travel Guide</h2></a>
        <a href="${pageContext.request.contextPath}/home" class="land-nav-link"><h2>Home</h2></a>
    </nav>
</header>

<section class="land-hero">
    <div class="land-hero-inner">
        <span class="land-hero-tag">Project Team</span>
        <h1 class="land-hero-title">Meet the <span class="land-hero-accent">Developers</span></h1>
        <p class="land-hero-desc">The team behind SkyLine Airline Reservation and Management System.</p>
    </div>
</section>

<section class="travel-page-section">
    <div class="developer-grid">

        <article class="developer-card" onclick="showDeveloperPopup(0)">
            <div class="developer-photo">
                <img src="${pageContext.request.contextPath}/static/images/Krits.jpg" alt="Kritagya"/>
                <span>CEO</span>
            </div>
            <div><h2>Kritagya Shrestha</h2><p>Designed frontend UI and supported backend development for smooth system functionality.</p></div>
        </article>

        <article class="developer-card" onclick="showDeveloperPopup(1)">
            <div class="developer-photo">
                <img src="${pageContext.request.contextPath}/static/images/SujalP.jpg" alt="SujalP"/>
                <span>Co-Founder</span>
            </div>
            <div><h2>Sujal Pariyar</h2><p>Created wireframes, analyzed UI structure, and contributed to backend development.</p></div>
        </article>

        <article class="developer-card" onclick="showDeveloperPopup(2)">
            <div class="developer-photo">
                <img src="${pageContext.request.contextPath}/static/images/SujalT.jpg" alt="SujalT"/>
                <span>IT Systems Manager</span>
            </div>
            <div><h2>Sujal Tiwari</h2><p>Developed and normalized the database while assisting in backend operations.</p></div>
        </article>

        <article class="developer-card" onclick="showDeveloperPopup(3)">
            <div class="developer-photo">
                <img src="${pageContext.request.contextPath}/static/images/Binod.jpg" alt="Binod"/>
                <span>UI/UX </span>
            </div>
            <div><h2>Binod Tamang</h2><p>Designed UI/UX interfaces and prepared ERD and relational database models.</p></div>
        </article>

        <article class="developer-card" onclick="showDeveloperPopup(4)">
            <div class="developer-photo">
                <img src="${pageContext.request.contextPath}/static/images/Prajesh.jpg" alt="Prajesh"/>
                <span>System Tester</span>
            </div>
            <div><h2>Prajesh Thapa</h2><p>Assisted in database development and performed system testing for reliability.</p></div>
        </article>

        <article class="developer-card" onclick="showDeveloperPopup(5)">
            <div class="developer-photo">
                <img src="${pageContext.request.contextPath}/static/images/Aditya.jpg" alt="Aditya"/>
                <span>Quality Analyst</span>
            </div>
            <div><h2>Aditya Ale Magar</h2><p>Managed quality assurance and analyzed system performance and usability.</p></div>
        </article>

    </div>
</section>

<!-- Popup -->
<div class="developer-popup" id="devPopup">
    <div class="popup-content">
        <div class="popup-photo" id="popupPhoto">
            <img id="popupImg" src="" alt="" style="width:100%;height:280px;object-fit:cover;"/>
        </div>
        <div class="popup-info">
            <h2 id="popupName"></h2>
            <p class="popup-role" id="popupRole"></p>
            <p class="popup-desc" id="popupDesc"></p>
            <button class="close-btn" onclick="closePopup()">Close</button>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/partials/landing-footer.jsp"/>

<script>
    const ctx = '<%= request.getContextPath() %>';

    const developers = [
        { photo: ctx + "/static/images/Krits.jpg",   name: "Kritagya Shrestha",  role: "CEO",                    desc: "Responsible for designing interactive user interfaces, developing responsive frontend components, and supporting backend functionality to ensure a seamless user experience within the SkyLine Airlines system." },
        { photo: ctx + "/static/images/SujalP.jpg",  name: "Sujal Pariyar",      role: "Co-Founder",             desc: "Conducted user interface analysis, created system wireframes and layout structures, and contributed to backend development to improve overall system usability and functionality." },
        { photo: ctx + "/static/images/SujalT.jpg",  name: "Sujal Tiwari",       role: "IT Systems Manager",         desc: "Managed database creation, normalization, and data structure optimization while assisting in backend development to ensure efficient system performance and secure data management." },
        { photo: ctx + "/static/images/Binod.jpg",   name: "Binod Tamang",        role: "UI/UX",             desc: "Designed user-friendly UI/UX components, developed frontend visuals, and prepared ERD and relational database models to support accurate system architecture and database relationships." },
        { photo: ctx + "/static/images/Prajesh.jpg", name: "Prajesh Thapa",       role: "System Tester",      desc: "Assisted in database creation and performed system testing to identify errors, validate functionalities, and ensure the reliability and stability of the application." },
        { photo: ctx + "/static/images/Aditya.jpg",  name: "Aditya Ale Magar",    role: "Quality Analyst",        desc: "Oversaw quality assurance processes, evaluated system performance and usability, and ensured that the project met required standards, functionality, and user expectations." }
    ];

    function showDeveloperPopup(index) {
        const dev = developers[index];
        const img = document.getElementById('popupImg');
        img.src = dev.photo;
        img.alt = dev.name;
        document.getElementById('popupName').textContent = dev.name;
        document.getElementById('popupRole').textContent = dev.role;
        document.getElementById('popupDesc').textContent = dev.desc;
        document.getElementById('devPopup').style.display = 'flex';
    }

    function closePopup() {
        document.getElementById('devPopup').style.display = 'none';
    }

    document.getElementById('devPopup').addEventListener('click', function(e) {
        if (e.target === this) closePopup();
    });
</script>
</body>
</html>

