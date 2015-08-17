require 'spec_helper'

describe Slacken do
  describe '#translate' do
    subject { described_class.translate(source) }

    context 'when h1 is given' do
      let(:source) do
        <<-EOS.unindent
          <h1>
            <span id="heading-bold"></span>
            <a><i class="fa fa-link"></i></a>
            heading <em>italic</em> <strong>bold</strong>
          </h1>
        EOS
      end

      it 'wraps inner text with "*"' do
        should eq '*heading _italic_ bold*'
      end
    end

    context 'when p is given' do
      let(:source) { '<p>hello world</p>' }

      it 'returns inner text' do
        should eq "hello world"
      end
    end

    context 'when br is given' do
      let(:source) { '<p>hello<br>world</p>' }

      it 'converts br into new line char' do
        should eq "hello\nworld"
      end
    end

    context 'when em is given' do
      let(:source) { '<p><em>italic</em></p>' }

      it 'wraps inner text with "_"' do
        should eq '_italic_'
      end
    end

    context 'when string is given' do
      let(:source) { '<p><strong>bold</strong></p>' }

      it 'wraps inner text with "*"' do
        should eq '*bold*'
      end
    end

    context 'when code is given' do
      let(:source) { '<p><code>code</code></p>' }

      it 'wraps inner text with "`"' do
        should eq '`code`'
      end
    end

    context 'when emoji img is given' do
      let(:source) do
        <<-EOS.unindent
          <p>
          hello
          <img  class="emoji" title=":eyes:" alt=":eyes:" src="https://cdn.qiita.com/emoji/unicode/1f440.png" height="20" width="20" align="absmiddle">
          world
          <img class="emoji" title=":bowtie:" alt=":bowtie:" src="https://cdn.qiita.com/emoji/bowtie.png" height="20" width="20" align="absmiddle">
          </p>
        EOS
      end

      it 'replaces img elements with corresponding emoji notation' do
        should eq 'hello :eyes: world :bowtie:'
      end
    end

    context 'when nested ul, ol and li elements are given' do
      let(:source) do
        <<-EOS.unindent
          <ol>
          <li>リスト1
          <ul>
          <li>リスト1-1</li>
          <li>リスト1-2</li>
          </ul>
          </li>
          <li>リスト2
          <ol>
          <li>リスト2-1</li>
          </ol>
          </li>
          </ol>
        EOS
      end

      it 'converts to list notation' do
        should eq <<-EOS.unindent.chomp
        1. リスト1
            • リスト1-1
            • リスト1-2
        2. リスト2
            1. リスト2-1
        EOS
      end
    end

    context 'when task lists are given' do
      let(:source) do
        <<-EOS.unindent
          <ul>
          <li class="task-list-item">
          <input type="checkbox" class="task-list-item-checkbox" checked disabled>Checked item</li>
          <li class="task-list-item">
          <input type="checkbox" class="task-list-item-checkbox" disabled>Unchecked item</li>
          </ul>
        EOS
      end

      it 'converts to list notation with ascii checkbox' do
        should eq <<-EOS.unindent.chomp
          • [x] Checked item
          • [ ] Unchecked item
        EOS
      end
    end

    context 'when dl is given' do
      let(:source) do
        <<-EOS.unindent
          <dl>
          <dt>定義語リストとは？</dt>
          <dd>こんなかんじで単語の意味を説明していくリストです。</dd>
          <dt>他の単語</dt>
          <dd>ここに説明を書く</dd>
          </dl>
        EOS
      end

      it 'converts to list notation' do
        should eq <<-EOS.unindent.chomp
          • 定義語リストとは？
          • こんなかんじで単語の意味を説明していくリストです。
          • 他の単語
          • ここに説明を書く
        EOS
      end
    end

    context 'when blockquote is given' do
      let(:source) do
        <<-EOS.unindent
          <blockquote>
          <p>この文字列は引用されたものです<br>
          インデントされているはず<br>
          これはもインデントされている</p>
          </blockquote>

          <p>これはインデントされない</p>
        EOS
      end

      it 'inserts ">" to each lines' do
        should eq <<-EOS.unindent.chomp
          > この文字列は引用されたものです
          > インデントされているはず
          > これはもインデントされている

          これはインデントされない
        EOS
      end
    end

    context 'when code block is given' do
      let(:source) do
        <<-EOS.unindent
          <div class="code-frame" data-lang="rb"><div class="highlight"><pre><span class="k">class</span> <span class="nc">Klass</span>
            <span class="k">def</span> <span class="nf">method</span>
              <span class="nb">puts</span> <span class="s1">'method called!'</span>
            <span class="k">end</span>
          <span class="k">end</span>
          </pre></div></div>
        EOS
      end

      it 'wraps inner text with "```"' do
        should eq <<-EOS.unindent.chomp
          ```class Klass
            def method
              puts 'method called!'
            end
          end
          ```
        EOS
      end
    end

    context 'when table is given' do
      let(:source) do
        <<-EOS.unindent
          <table>
          <thead>
          <tr>
          <th>Header1</th>
          <th>Header2</th>
          </tr>
          </thead>
          <tbody>
          <tr>
          <td>Cell1</td>
          <td>Cell2</td>
          </tr>
          <tr>
          <td>hello</td>
          <td>world</td>
          </tr>
          </tbody>
          </table>
        EOS
      end

      it 'converts html to table notation' do
        should eq <<-EOS.unindent.chomp
          +-------+-------+
          |Header1|Header2|
          +-------+-------+
          |Cell1  |Cell2  |
          |hello  |world  |
          +-------+-------+
        EOS
      end
    end

    context 'when table with empty td is given' do
      let(:source) do
        <<-EOS.unindent
          <table>
          <thead>
          <tr>
          <th>Header1</th>
          <th>Header2</th>
          </tr>
          </thead>
          <tbody>
          <tr>
          <td>A</td>
          <td></td>
          </tr>
          <tr>
          <td>B</td>
          <td>C</td>
          </tr>
          </tbody>
          </table>
        EOS
      end

      it 'converts html to table notation' do
        should eq <<-EOS.unindent.chomp
          +-------+-------+
          |Header1|Header2|
          +-------+-------+
          |A      |       |
          |B      |C      |
          +-------+-------+
        EOS
      end
    end

    context 'when table without thead is given' do
      let(:source) do
        <<-EOS.unindent
          <table>
          <tr>
          <td>Without</td>
          </tr>
          <tr>
          <td>thead</td>
          </tr>
          </table>
        EOS
      end

      it 'converts html to table notation' do
        should eq <<-EOS.unindent.chomp
          +-------+
          |Without|
          |thead  |
          +-------+
        EOS
      end
    end

    context 'when empty table is given' do
      let(:source) { '<table></table>' }

      it { should eq '' }
    end

    context 'when img is given' do
      let(:source) { "<p><img src='#{src}' alt='#{alt}'></p>" }
      let(:src) { 'http://cdn.qiita.com/logo.png' }
      let(:alt) { 'Qiita logo' }

      it 'convert inner text to img notation' do
        should eq "<#{src}|#{alt}>"
      end
    end

    context 'when img in a is given' do
      let(:source) { "<p><a href='#{src}'><img src='#{src}' alt='#{alt}'></a></p>" }
      let(:src) { 'http://cdn.qiita.com/logo.png' }
      let(:alt) { 'Qiita logo' }

      it 'ignores the link' do
        should eq "<#{src}|#{alt}>"
      end
    end

    context 'when a is given' do
      let(:source) { '<p><a href="http://qiita.com">qiita</a></p>' }

      it 'converts to link notation' do
        should eq "<http://qiita.com|qiita>"
      end
    end

    context 'when hr is given' do
      let(:source) do
        <<-EOS.unindent
          <p>before</p>
          <hr>
          <p>after</p>
        EOS
      end

      it 'converts to "-----------"' do
        should eq <<-EOS.unindent.chomp
          before

          -----------

          after
        EOS
      end
    end

    context 'when del is given' do
      let(:source) { '<del>ignore</del>' }

      it 'returns inner text' do
        should eq 'ignore'
      end
    end
  end
end
