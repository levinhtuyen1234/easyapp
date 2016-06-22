<window-login>
    <!-- HTML TAG START -->
    <div class="jumbotron jumbotron-home jumbotron-inverse" style="margin-bottom:1px;">
      <div class="container-responsive">
        <div class="columns">
          <div class="homepage-hero-intro column">
            <h1 class="display-heading-1 jumbotron-title">How people build website</h1>
            <p class="display-intro jumbotron-lead">Millions of developers use EasyWebHub to build personal, company, blog, ecommerce websites, support their businesses, and&nbsp;work together on open source technologies.</p>
          </div>
          <div class="homepage-hero-signup column">
              <div class="d-none-sm-dn">
                <!-- </textarea> --><!-- '"` --><form accept-charset="UTF-8" action="/join" autocomplete="off" class="home-hero-signup js-signup-form" data-form-nonce="652353d3ac5a112c9df6b943ad60e6cc2eaf1e0d" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="+xi468NyjI9V5dnz2n7llB9ykjAyiy/rvpuqdraF8pu5Nx79kfw/lPf8yHI2rC2QsWsJY10EZ3EqWoOv7pOSYQ==" /></div>              <dl class="form">
                    <dd>
                      <label class="form-label sr-only" for="user[login]">Pick a username</label>
                      <input type="text" name="user[login]" class="form-control form-control-lg input-block" placeholder="Pick a username" data-autocheck-url="/signup_check/username" autofocus>
                    </dd>
                  </dl>
                  <dl class="form">
                    <dd>
                      <label class="form-label sr-only" for="user[email]">Enter your email address</label>
                      <input type="text" name="user[email]" class="form-control form-control-lg input-block js-email-notice-trigger" placeholder="Your email address" data-autocheck-url="/signup_check/email">
                    </dd>
                  </dl>
                  <dl class="form">
                    <dd>
                      <label class="form-label sr-only" for="user[password]">Create a password</label>
                      <input type="password" name="user[password]" class="form-control form-control-lg input-block" placeholder="Create a password" data-autocheck-url="/signup_check/password">
                    </dd>
                    <p class="form-control-note">Use at least one letter, one numeral, and seven characters.</p>
                  </dl>
                  <input type="hidden" name="source" class="js-signup-source" value="form-home">
                  <button class="btn btn-theme-green btn-jumbotron btn-block" onclick="{login}" type="submit">Sign in for EasyWeb</button>
                </form>
              </div>

          </div>
        </div>
      </div>
    </div>

    <div class="featurette pb-0 pt-6 shade-gray border-top">
      <div class="container-responsive">
        <h2 class="featurette-heading display-heading-2 mt-3 text-center">Welcome home, website and apps developers</h2>
        <p class="featurette-lead featurette-lead-center display-intro mb-6 pb-0">EasyWebHub fosters a fast, flexible, and collaborative
          enviroment that lets you build websites on your own or with others.</p>
      </div>
      <div class="tile-block">
        <div class="tile-row">
          <div class="tile tile-bordered one-fourth text-center">
            <img src="https://assets-cdn.github.com/images/modules/site/home-ill-build.png?sn" alt="" class="img-responsive featurette-illo-sm mb-4 mt-4">
            <h4 class="display-heading-4">Sign In | Sign up</h4>
            <p class="display-body-sm">Everything is synchronized on EasyWebHub Cloud to help you collaborate with others.</p>
          </div>
          <div class="tile tile-bordered one-fourth text-center">
            <img src="https://assets-cdn.github.com/images/modules/site/home-ill-work.png?sn" alt="" class="img-responsive featurette-illo-sm mb-4 mt-4">
            <h4 class="display-heading-4">Choose a website</h4>
            <!--<p class="display-body-sm">Create new website from a lot of EasyWebHub website templates. Or continue with existing one.</p>-->
            <p class="display-body-sm">Create a new website or continue with existing one.</p>
          </div>
          <div class="tile tile-bordered one-fourth text-center">
            <img src="https://assets-cdn.github.com/images/modules/site/home-ill-projects.png?sn" alt="" class="img-responsive featurette-illo-sm mb-4 mt-4">
            <h4 class="display-heading-4">Build and Preview</h4>
            <!-- <p class="display-body-sm">You can customize everthing, from content to layout and configuration, but allow to control other by account permissions.
            You can preview what you did in realtime</p> -->
            <p class="display-body-sm">You can customize everthing and preview it realtime</p>
          </div>
          <div class="tile tile-bordered one-fourth text-center">
            <img src="https://assets-cdn.github.com/images/modules/site/home-ill-platform.png?sn" alt="" class="img-responsive featurette-illo-sm mb-4 mt-4">
            <h4 class="display-heading-4">One platform, from start to public</h4>
            <p class="display-body-sm">The website will go live just by One-Click Publication.</p>
          </div>
        </div>
      </div>
    </div>
    <div class="featurette pb-0">
      <div class="container-responsive">
          <h2 class="featurette-heading display-heading-2 mt-3">How to build website?</h2>
          <div class="pricing-card pricing-card-horizontal"> <div class="pricing-card-cta">
          <a class="btn btn-block btn-theme-green btn-jumbotron" onclick="{openTutorial}" rel="nofollow">Hướng dẫn sử dụng</a> </div>
          <div class="pricing-card-text display-heading-3 mb-0 text-thin">EasyWebHub cung cấp tất cả các thông tin bạn cần để xây dựng website, từ cơ bản như trang blog cá nhân tới phức tạp như website Ecommerce.</div> </div>
      </div>
    </div>

        </div>



    <!-- HTML TAG END -->

    <script>
        var me = this;
        me.login = function() {
            me.unmount();
            riot.mount('landing');
        }
        const BrowserWindow = require('electron').remote.BrowserWindow
        const newWindowBtn = document.getElementById('frameless-window')

        me.openTutorial = function (event) {
          let win = new BrowserWindow({ frame: true,   width:1280, minWidth: 1080, height:   840, icon:     'favicon.ico' })
          win.on('closed', function () { win = null })
          win.loadURL('http://book.easywebhub.com/')
          win.show()
        }
    </script>
</window-login>
