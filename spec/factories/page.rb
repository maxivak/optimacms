FactoryGirl.define do
  sequence(:page_title) { |n| "Page title #{n}" }

  factory :page do
    #user.company
    title "page"+Faker::Number.number(10)
    title "this is page "+Faker::Number.number(10)
    #title work_title
    #title sequence(:title) { |n| "work title #{n}" }
    #description "some desc"

  end

  factory :page_basic, class: Page do
    name "page1"
    title "page "+Faker::Number.number(10)

  end


  factory :page_with_code, class: Page do
    name "mypage"
    title "sample page"
  end

end