require 'spec_helper'

describe HtmlStripper do
  it 'has a version number' do
    expect(HtmlStripper::VERSION).not_to be nil
  end

  context '.new' do
    it 'can be initialized with option Hash' do
      expect { HtmlStripper.new({}) }.not_to raise_error
    end
  end

  let(:default_stripper) { HtmlStripper.new }

  context '#run' do
    context '(with default setting)' do
      default_tests = [
        {
          title: 'strips HTML comment',
          source: '<test><!-- hoge --><foo /><!----></test>',
          expected: '<test><foo /></test>'
        },
        {
          title: 'unifies multiple newlines and spaces to one newline',
          source: "<test>  \n \n </test><test2>\n\n</test2>",
          expected: "<test>\n</test><test2>\n</test2>"
        },
        {
          title: 'minifies continuous spaces and tabs outside tags to one space',
          source: "<test>   <test2>\t \t</test2></test>",
          expected: '<test> <test2> </test2></test>'
        },
        {
          title: "doesn't change continuous spaces inside tags",
          source: '<test  attr1=" val "  ><test2   /> </test>'
        },
        {
          title: 'keeps anything inside style, script, textarea, pre tags',
          source: "<style><!-- foo --></style><script async>\n\t\n</script>" \
                  "<textarea>   </textarea><pre>\t\t\n\n\t\t</pre>"
        },
        {
          title: 'keeps inside CDATA section',
          source: "<![CDATA[\n\n\t  <!-- saaa -->  ]]>"
        },
        {
          title: 'keeps conditional comments',
          source: '<!--[if ie]> foo <![endif]--><!--[if !IE]><!--> bar <!--<![endif]-->'
        }
      ]

      default_tests.each do |test|
        it test[:title] do
          expect(default_stripper.run(test[:source]))
            .to eq(test[:expected] || test[:source])
        end
      end
    end
  end
end
