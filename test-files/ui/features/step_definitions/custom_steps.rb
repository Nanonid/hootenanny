Given(/^I am on Hootenanny$/) do
  visit "http://localhost:" + (ENV['TOMCAT_PORT'] ? ENV['TOMCAT_PORT'] : "8080") + "/hootenanny-id" # may need to change URL
end

When(/^I click Get Started$/) do
  begin
    el = find_button('Get Started')
  rescue Capybara::ElementNotFound
    # In Capybara 0.4+ #find_field raises an error instead of returning nil
    el = nil
  end
  el.click unless el.nil?
end

When(/^I click the "([^"]*)" link$/) do |linkText|
  find('a', :text=> linkText).click
end

When(/^I click the "([^"]*)" classed link under "([^"]*)"$/) do |classed, parent|
  find('div.' + parent).find('a.' + classed).click
end

Then(/^I should see "([^"]*)"$/) do |text|
  page.should have_content(text)
end

Then(/^I should not see "([^"]*)"$/) do |text|
  page.should have_no_content(text)
end

When(/^I select the "([^"]*)" div$/) do |cls|
  find('div.' + cls).click
  sleep 1
end

When(/^I select the first "([^"]*)" div$/) do |cls|
  all('div.' + cls).first.click
end

When(/^I select the last "([^"]*)" div$/) do |cls|
  all('div.' + cls).last.click
end

When(/^I click the "([^"]*)" Dataset$/) do |dataset|
  text = page.find('text',:text=>dataset, :match => :prefer_exact)
  parent = text.find(:xpath,"..")
  parent.find('rect').click
end

When(/^I click first "([^"]*)"$/) do |text|
  Capybara.ignore_hidden_elements = false
  elements = all('a', :text => text)
  if elements.empty?
    elements = all(:xpath, '//input[@value="' + text + '"]')
  end
  elements[0].click
  Capybara.ignore_hidden_elements = true
end

When(/^I click second "([^"]*)"$/) do |text|
  Capybara.ignore_hidden_elements = false
  e1 = all('a', :text => text)
  e2 = all(:xpath, '//input[@value="' + text + '"]')
  elements = combine(e1, e2)
  elements[1].click
  Capybara.ignore_hidden_elements = true
end

When(/^I click the "([^"]*)" key$/) do |arg1|
  find("body").native.send_keys(arg1)
end

Then(/^I should see options in this order:$/) do |table|
  expected_order = table.raw.flatten
  actual_order = page.all('#settingsSidebar label').collect(&:text)
  actual_order.should == expected_order
end

Then(/^I click on the "([^"]*)" option in the "([^"]*)"$/) do |label,div|
  find('#' + div).find('label', :text => label).click
end

When(/^I select the "([^"]*)" option in the "([^"]*)" combobox$/) do |opt, cb|
  combobox = page.find(:css, 'input[placeholder="' + cb + '"]')
  combobox.find(:xpath, '..').find('.combobox-caret').click
  find('a', :text=> opt).click
end

When(/^I click the "([^"]*)" button$/) do |el|
  find('button.' + el).click
end

When(/^I click the "([^"]*)" button and accept the alert$/) do |el|
  find('button.' + el).click
  page.driver.browser.switch_to.alert.accept
end

When(/^I click the "([^"]*)" at "([^"]*)","([^"]*)"$/) do |el, x, y|
  find('#' + el).click_at(x,y)
  sleep 3
end

When(/^I double-click the "([^"]*)"$/) do |el|
  find('#' + el).double_click
  sleep 1
end

When(/^I fill "([^"]*)" with "([^"]*)"$/) do |el, value|
  find('#' + el).set(value)
  sleep 1
end

When(/^I fill "([^"]*)" input with "([^"]*)"$/) do |el, value|
  find('input.' + el).set(value)
  sleep 1
end

When(/^I fill input under "([^"]*)" with "([^"]*)"$/) do |parent, value|
  all('div.' + parent).last.find('input[type="text"]').set(value)
  sleep 1
end

When(/^I press enter in the "([^"]*)" input$/) do |selector|
  find('input' + selector).native.send_keys(:enter)
end

When(/^I press tab in the "([^"]*)" input$/) do |selector|
  find('input' + selector).native.send_keys(:tab)
end

When(/^I press escape in the "([^"]*)" input$/) do |selector|
  find('input' + selector).native.send_keys(:escape)
end

When(/^I press the left arrow key$/) do
  find('body').native.send_keys(:arrow_left)
end

When(/^I press the right arrow key$/) do
  find('body').native.send_keys(:arrow_right)
end

When(/^I press the up arrow key on "([^"]*)"$/) do |target|
  find(target).native.send_keys(:arrow_up)
end

When(/^I press the down arrow key on "([^"]*)"$/) do |target|
  find(target).native.send_keys(:arrow_down)
end

When(/^I press "([^"]*)"$/) do |button|
  click_link_or_button(button)
end

When(/^I hover over "([^"]*)"$/) do |el|
  find(el).hover
end

When(/^I press "([^"]*)" big loud span$/) do |txt|
  find('span.big.loud', :text=>txt).click
end

When(/^I wait$/) do
  sleep 5
end

When(/^I remove the first layer$/) do
  trash_cans = all('button._icon.trash')
  trash_cans[0].click
  sleep 5
  page.driver.browser.switch_to.alert.accept
  sleep 2
end

When(/^I wait ([0-9]*) "([^"]*)" to see "([^"]*)"$/) do |timeout, unit, text|
  if unit == "seconds"
    multiplier = 1
  elsif unit == "minutes"
    multiplier = 60
  else
    throw :badunits
  end
  oldTimeout = Capybara.default_max_wait_time
  Capybara.default_max_wait_time = Float(timeout) * multiplier
  page.should have_content(text)
  Capybara.default_max_wait_time = oldTimeout
end

When(/^I wait ([0-9]*) "([^"]*)" to not see "([^"]*)"$/) do |timeout, unit, text|
  if unit == "seconds"
    multiplier = 1
  elsif unit == "minutes"
    multiplier = 60
  else
    throw :badunits
  end
  oldTimeout = Capybara.default_max_wait_time
  Capybara.default_max_wait_time = Float(timeout) * multiplier
  page.should have_no_content(text)
  Capybara.default_max_wait_time = oldTimeout
end

When(/^I close the UI alert$/) do
  find('#alerts').all('.x')[0].click
end

When(/^I scroll element into view and press "([^"]*)"$/) do |id|
  Capybara.ignore_hidden_elements = false
  element = page.driver.browser.find_element(:id, id)
  page.driver.browser.execute_script("arguments[0].scrollIntoView(true)", element)
  element.click
  Capybara.ignore_hidden_elements = true
end

Then(/^I resize the window$/) do
  if Capybara.javascript_driver != :webkit
    window = Capybara.current_session.driver.browser.manage.window
    window.resize_to(1920, 1080) # width, height
  end
end

When(/^I upload a shapefile/) do
  include_hidden_fields do
    # Seems to be a bug where only the last file in the array gets attached.
    # Then can't be attached separately because then each file gets uploaded
    # individually.
    page.attach_file('taFiles', [ENV['HOOT_HOME'] + '/test-files/translation_assistant/cali-test.shp', ENV['HOOT_HOME'] + '/test-files/translation_assistant/cali-test.dbf', ENV['HOOT_HOME'] + '/test-files/translation_assistant/cali-test.shx', ENV['HOOT_HOME'] + '/test-files/translation_assistant/cali-test.prj'])
    # page.execute_script("var event = document.createEvent('Event'); event.initEvent('change', true, true); d3.select('input[name=taFiles]').node().dispatchEvent(event);")
    puts page.driver.browser.manage.logs.get("browser")
  end
end

When(/^I upload a zipped shapefile/) do
  include_hidden_fields do
    page.attach_file('taFiles', ENV['HOOT_HOME'] + '/test-files/translation_assistant/cali-test.zip')
  end
end

When(/^I upload a zipped folder of shapefiles/) do
  include_hidden_fields do
    page.attach_file('taFiles', ENV['HOOT_HOME'] + '/test-files/translation_assistant/calizip.zip')
  end
end

When(/^I upload an invalid dataset/) do
  include_hidden_fields do
    page.attach_file('taFiles', ENV['HOOT_HOME'] + '/test-files/translation_assistant/cali-test.shx')
  end
end

Then(/^I take a screenshot/) do
  screenshot_and_save_page
end

Then(/^I type "([^"]*)" in input "([^"]*)"$/) do |text, id|
  page.fill_in id, :with => text
end

Then(/^I click the "([^"]*)" with text "([^"]*)"$/) do |el, text|
  page.find(el, :text => text)
end

Then(/^I accept the alert$/) do
  page.driver.browser.switch_to.alert.accept
end

Then(/^I should see element "([^"]*)" with value "([^"]*)"$/) do |id, value|
  # expect(page).to have_selector("input[value='" + value + "']")
  # page.should have_xpath("//input[@value='" + value + "']")
  find(id).value.should eq value
end

Then(/^I choose "([^"]*)" radio button$/) do |text|
  choose(text)
end

Then(/^I POST coverage info$/) do
  page.execute_script("(function () { if (window.__coverage__) { d3.xhr('http://localhost:8880/coverage/client').header('Content-Type', 'application/json').post(JSON.stringify(window.__coverage__),function(err, data){});}}())");
end
