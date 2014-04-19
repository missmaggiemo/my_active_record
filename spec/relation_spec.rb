require 'my_active_record/searchable'
require 'my_active_record/relation'

describe 'Searchable' do
  before(:each) { DBConnection.reset }
  after(:each) { DBConnection.reset }

  before(:all) do
    class Cat < SQLObject
    end

    class Human < SQLObject
      self.table_name = 'humans'
    end
  end

  it '#where works with .first' do
    cats = Cat.where(name: 'Breakfast')
    cat = cats.first

    expect(cats.length).to eq(1)
    expect(cat.name).to eq('Breakfast')
  end

  it '#where works with .length' do
    humans = Human.where(house_id: 1)
    expect(humans.length).to eq(2)
  end
  
  it '#where works with .each' do
    humans = Human.where(house_id: 1)
    human_arr = []
    humans.each {|h| human_arr << h}
    expect(human_arr.length).to eq(2)
  end
  
  it '#where works with .map' do
    humans = Human.where(house_id: 1)
    human_arr = humans.map {|h| [h, 1]}
    expect(human_arr.first.length).to eq(2)
  end

  it '#where with multiple criteria works with .length' do
    humans = Human.where(fname: 'Matt', house_id: 1)
    expect(humans.length).to eq(1)

    human = humans[0]
    expect(human.fname).to eq('Matt')
    expect(human.house_id).to eq(1)
  end
  
  it '#where with multiple criteria works with .first' do
    human = Human.where(fname: 'Matt', house_id: 1).first

    expect(human.fname).to eq('Matt')
    expect(human.house_id).to eq(1)
  end
  
  it '#where chained works with .first' do
    humans = Human.where(fname: 'Matt').where(house_id: 1)
    expect(humans.length).to eq(1)

    human = humans[0]
    expect(human.fname).to eq('Matt')
    expect(human.house_id).to eq(1)
  end
  
  it '#where chained works with .length' do
    humans = Human.where(fname: 'Matt').where(house_id: 1)
    expect(humans.length).to eq(1)

    human = humans[0]
    expect(human.fname).to eq('Matt')
    expect(human.house_id).to eq(1)
  end
  
  
end