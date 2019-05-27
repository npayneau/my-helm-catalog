require 'net/http'
require 'uri'

SCHEDULER.every '30s' do
  send_event('portainerService', { status: checkService("{{ scheme + '://' + pic_subdomain + '.' + public_domain  if pic_subdomain else external_url }}/portainer/") })

  send_event('gitlabService', checkService("{{ gitlab_external_url }}"))

  send_event('jenkinsService', checkService("{{ jenkins_external_url }}/login"))

  send_event('sonarqubeService', checkService("{{sonarqube_external_url }}"))
  
  send_event('nexusService', checkService("{{ nexus_external_url }}"))
end

def checkService(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.read_timeout = 10
    if uri.scheme == "https"
        http.use_ssl=true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    request = Net::HTTP::Get.new(uri.request_uri)
    begin
        response = http.request(request)
    rescue
        return { status: "dead"}
    end

    if !response.nil? && (response.code == "200" || response.code == "302")
      return { status: "open"}
    else
      return { status: "dead"}
    end
end