require 'fox16'
include Fox

class ColoredButton < FXButton
  def initialize(parent, color)
    super(parent, '', :opts => BUTTON_NORMAL|LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT, :width => 50, :height => 50)
    self.backColor = :white
    @window = self.parent.parent
    self.connect(SEL_COMMAND) do
      self.backColor = color
      if @window.button1 == nil
        @window.button1 = self
      elsif @window.button2 == nil and @window.button1 != nil
        @window.button2 = self
        if @window.button1.backColor == self.backColor
          @window.disable
          @window.button1.disable
          @window.button2.disable
          @window.button1 = nil
          @window.button2 = nil
          @window.enable
          @window.count = @window.count + 1
        elsif @window.button1.backColor != self.backColor
          @window.disable
          app.addTimeout(500) do
            @window.button1.backColor = :white
            @window.button2.backColor = :white
            @window.button1 = nil
            @window.button2 = nil
            @window.enable
          end
        end
      end
    end
  end
end



class ColoredButtonsDemo < FXMainWindow
  attr_accessor :button1, :button2, :count
  def initialize(app)
    super(app, 'Memory')
    @count = 0
    @button1 = nil
    @button2 = nil
    @mtx = FXMatrix.new(self, 4)
    ([:red, :green, :blue, :yellow, :orange, :cyan, :purple, :pink, :black, :brown]*2).each do |color|
      ColoredButton.new(@mtx, color)
    end
  end

  def create
    super
    self.show(PLACEMENT_SCREEN)
  end
end
app=FXApp.new
ColoredButtonsDemo.new(app)
app.create
app.run
if @count == 10
  app.quit
  winner = FXApp.new
  FXMainWindow.new(winner, 'WINNER!')
  FXMainWindow.enable
end