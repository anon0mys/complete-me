require './complete_me'

engine = CompleteMe.new

Shoes.app do

  stack(margin: 20) do 
    para "Enter a Substring"
    flow do
      @search_input = edit_line
      @search_button = button "Enter"
      @search_button.click{
        
        @results.replace(engine.suggest(@search_input.text()).join ', ')

    }
    end

    @results = para ''

    para "Import a Text File"

    flow do
      @file_path = edit_line('/usr/share/dict/words')
      @import = button 'Import'
      @import.click{
      
        dictionary = File.read(@file_path.text())

        engine.populate(dictionary)
        @feedback.replace('Imported')

      }
    end

    @feedback = para ''

    para 'Insert Word'

    flow do
      @insert_word = edit_line
      @insert_button = button 'Insert'
      @insert_button.click{
        
        word = @insert_word.text()
        engine.insert(word)
        @inserted.replace "#{word} inserted."

      }
    end

    @inserted = para ''

    para 'Select Words'

    flow do
      @selection_one = edit_line('select prefix')
      @selection_two = edit_line('select word')
      @selection_button = button 'Select Word'
      @selection_button.click{

        s_one = @selection_one.text()
        s_two = @selection_two.text()
        engine.select(s_one, s_two)
        @select.replace("#{s_one}: #{engine.find_node(s_two).weight_holder}")

      }
    end

    @select = para ''


  para 'Delete a Word'

    flow do
      @deletion = edit_line
      @delete_button = button 'Delete'
      @delete_button.click{

        remove = @deletion.text()
        engine.delete(remove)
        @deleted.replace(@deletion.text() + ' has been removed.')

      }
    end

    @deleted = para ''

  end
end