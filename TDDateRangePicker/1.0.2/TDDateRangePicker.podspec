Pod::Spec.new do |s|
    s.name             = 'TDDateRangePicker'
    s.version          = '1.0.2'
    s.summary          = 'TDDateRangePicker is a picker with which you can get both a date range and one date and it is all with beautiful designs.'

    s.description      = <<-DESC
    TDDateRangePicker is a picker with which you can get both a date range and one date and it is all with beautiful designs. We have taken into account all the conditions of its usage. The library includes custom TDDateRangePicker and a TDPickerTheme which allow you to customize the appearance of the picker.
    DESC

    s.homepage         = 'http://topdevs.org'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Andrew' => 'andrew@topdevs.org' }
    s.source           = { :git => 'https://github.com/TheTopDevs/TDDateRangePicker.git', :branch => "master", :tag => s.version.to_s }

    s.ios.deployment_target = '10.0'
    s.source_files          = 'TDDateRangePicker/*.{h,m}'
    s.resource              = "TDDateRangePicker/*.{png,bundle,xib,nib}"

end
