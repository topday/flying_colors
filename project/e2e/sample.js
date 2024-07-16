
describe('dev::test', function() {

    before(browser => browser.setDeviceDimensions({
        width: 1280,
        height: 760,
    }).navigateTo('http://bee.lc:10380/'));

    it('Demo functional test', function(browser) {
        browser
            .waitForElementVisible('body')
						.pause(7000) // for presentation only
            .click("a[href='/service']")
            .waitForElementVisible('body')
						.pause(7000) // for presentation only
			      .assert.elementPresent('.slogan');
    });

    after(browser => browser.end());
});
