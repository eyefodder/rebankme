class BranchPresenter < BasePresenter
  presents :branch
  text_field_tags_for [:city, :zipcode, :state, :name, :telephone, :hours, :street]

  def bank_field_tag(form_builder)
    banks = Bank.all.map {|bank| [bank.name, bank.id]}
    options = h.options_for_select(banks, selected: branch.bank_id)
    select_field_tag(form_builder, :bank_id, options)
  end

  def state_field_tag(form_builder)
    selected = branch.state.blank? ? "NY" : branch.state
    options = h.options_for_select(us_states, selected: selected)
    select_field_tag(form_builder, :state, options)
  end






  def name_tag
    h.content_tag(:span, "#{@object.full_name} (#{branch.full_address})", class: 'editable-object-name')
  end

  private

  def us_states
    [
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CA'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Delaware', 'DE'],
      ['District of Columbia', 'DC'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Michigan', 'MI'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Puerto Rico', 'PR'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']
    ]
  end



end