
class CAPIInfo < Inspec.resource(1)
  name 'capi_info'
  desc 'Verify info about capi'

  example "
    describe capi_info do
      its('version') { should match /2.120/ }
    end
  "

  include ObjectTraverser

  attr_reader :params, :raw_content

  def initialize(_path = nil)
    @params = {}
    begin
      @capi = CAPI.new
      @params = @capi.info
    rescue => e
      raise Inspec::Exceptions::ResourceSkipped, "CAPI error: #{e}"
    end
  end

  def method_missing(*keys)
    # catch bahavior of rspec its implementation
    # @see https://github.com/rspec/rspec-its/blob/master/lib/rspec/its.rb#L110
    keys.shift if keys.is_a?(Array) && keys[0] == :[]
    value(keys)
  end

  def value(key)
    # uses ObjectTraverser.extract_value to walk the hash looking for the key,
    # which may be an Array of keys for a nested Hash.
    extract_value(key, params)
  end
end
