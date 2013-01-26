# Common test functions

def prepare_login(auth_file)
  authdata = YAML.load_file(File.join(File.dirname(__FILE__) + '/../partials', auth_file))
end

shared_context 'login is valid' do
  before do
    @api = prepare_login('valid.yaml')
  end
end
