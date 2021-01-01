require 'lightstep'

LightStep.configure(component_name: 'app-coupons-api', access_token: ENV['LIGHTSTEP_TOKEN'])
