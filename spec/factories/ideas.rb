FactoryGirl.define do
  factory :idea do
    # we tell FactoryGirl how to generate data for each field. We have the option to privide static data such as a string or an integer or we can provide a block. If you provide static data then it will be the same for all the records. If you provide a block then you can put some code to generate random or unique data.

    title         {|n| Faker::Company.bs + n.to_s}
    body          {Faker::ChuckNorris.fact}
  end
end
