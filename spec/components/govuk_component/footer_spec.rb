require 'spec_helper'

RSpec.describe(GovukComponent::Footer, type: :component) do
  subject do
    Capybara::Node::Simple.new(render_inline(component).to_html)
  end

  context 'when no arguments are supplied' do
    let(:component) { GovukComponent::Footer.new }

    specify 'the default licence info is included' do
      expect(subject).to have_css('footer.govuk-footer .govuk-footer__meta') do
        expect(page).to have_css('.govuk-footer__licence-description') do
          expect(page).to have_content(/All content is available under/)
          expect(page).to have_link("Open Government Licence v3.0", href: "https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/")
        end
      end
    end

    specify 'the default copyright information is included' do
      expect(subject).to have_css('footer.govuk-footer .govuk-footer__meta') do
        expect(page).to have_css('.govuk-footer__meta-item', text: %r{\&copy Crown copyright})
      end
    end

    specify 'the crown symbol is included' do
      expect(subject).to have_css('footer.govuk-footer .govuk-footer__meta') do
        expect(page).to have_css('svg', class: 'govuk-footer__licence-logo')
      end
    end
  end

  context 'when custom licence and copyright info are supplied' do
    let(:custom_copyright) { "All rights reserved" }
    let(:custom_copyright_url) { "https://en.wikipedia.org/wiki/All_rights_reserved" }
    let(:custom_licence_url) { "https://mit-license.org/" }
    let(:custom_licence) do
      %(Licenced under the <a href="#{custom_licence_url}">MIT Licence</a>.)
    end

    let(:component) { GovukComponent::Footer.new(licence: custom_licence, copyright_text: custom_copyright, copyright_url: custom_copyright_url) }

    specify 'the custom licence should have replaced the default' do
      expect(subject).to have_css('footer.govuk-footer .govuk-footer__meta') do
        within('.govuk-footer__licence-description') do
          expect(page).to have_content(custom_licence)
          expect(page).to have_link("MIT Licence", href: custom_licence_url)

          expect(page).not_to content(/All content is available under/)
        end
      end
    end

    specify 'the custom copyright should have replaced the default' do
      expect(subject).to have_css('footer.govuk-footer .govuk-footer__meta') do
        expect(page).to have_css('.govuk-footer__meta-item') do
          expect(page).to have_link(custom_copyright, href: custom_copyright_url)
        end
      end
    end
  end
end
