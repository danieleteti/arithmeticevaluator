program ExprEvaluator;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  ArithmeticParser in 'ArithmeticParser.pas';

var
  lParser: TArithmeticParser;
  lRes: Extended;
begin
  WriteLn('** SIMPLE ARITHMETIC EVALUATOR **');
  WriteLn('****** Daniele Teti - 2025 ******');
  WriteLn;
  try
    FormatSettings.DecimalSeparator := '.';
    lParser := TArithmeticParser.Create;
    try
      var lExpression := '';
      while True do
      begin
        Write('> ');
        Readln(lExpression);
        if lExpression = '' then
        begin
          Break;
        end;
        try
          lRes := lParser.Evaluate(lExpression);
          WriteLn(FloatToStr(lRes));
        except
          on E: Exception do
          begin
            WriteLn(E.Message);
          end;
        end;
      end;
    finally
      lParser.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
