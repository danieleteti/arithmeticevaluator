unit ArithmeticParser;

interface

uses
  SysUtils, Classes;

type
  TArithmeticParser = class
  private
    FInput: string;
    FPosition: Integer;
    FCurrentToken: Char;
    procedure Advance;
    procedure SkipWhitespace;
    function ParseExpression: Extended;
    function ParseTerm: Extended;
    function ParseFactor: Extended;
    function GetCurrentToken: Char;
    function ReadNumber: Extended;
  public
    function Evaluate(const Input: string): Extended;
  end;

implementation

procedure TArithmeticParser.Advance;
begin
  Inc(FPosition);
  if FPosition <= Length(FInput) then
    FCurrentToken := FInput[FPosition]
  else
    FCurrentToken := #0; // Fine dell'input
  SkipWhitespace;
end;

procedure TArithmeticParser.SkipWhitespace;
begin
  while (FPosition <= Length(FInput)) and (FInput[FPosition] = ' ') do
    Inc(FPosition);
  if FPosition <= Length(FInput) then
    FCurrentToken := FInput[FPosition]
  else
    FCurrentToken := #0;
end;

function TArithmeticParser.GetCurrentToken: Char;
begin
  if FPosition <= Length(FInput) then
    Result := FInput[FPosition]
  else
    Result := #0;
end;

function TArithmeticParser.ReadNumber: Extended;
var
  NumStr: string;
begin
  NumStr := '';
  while (FCurrentToken >= '0') and (FCurrentToken <= '9') do
  begin
    NumStr := NumStr + FCurrentToken;
    Advance;
  end;
  if FCurrentToken = '.' then
  begin
    NumStr := NumStr + FCurrentToken;
    Advance;
    while (FCurrentToken >= '0') and (FCurrentToken <= '9') do
    begin
      NumStr := NumStr + FCurrentToken;
      Advance;
    end;
  end;
  Result := StrToFloat(NumStr);
end;

function TArithmeticParser.ParseExpression: Extended;
var
  ResultTerm: Extended;
begin
  ResultTerm := ParseTerm;
  while (FCurrentToken = '+') or (FCurrentToken = '-') do
  begin
    if FCurrentToken = '+' then
    begin
      Advance;
      ResultTerm := ResultTerm + ParseTerm;
    end
    else if FCurrentToken = '-' then
    begin
      Advance;
      ResultTerm := ResultTerm - ParseTerm;
    end;
  end;
  Result := ResultTerm;
end;

function TArithmeticParser.ParseTerm: Extended;
var
  ResultFactor: Extended;
begin
  ResultFactor := ParseFactor;
  while (FCurrentToken = '*') or (FCurrentToken = '/') do
  begin
    if FCurrentToken = '*' then
    begin
      Advance;
      ResultFactor := ResultFactor * ParseFactor;
    end
    else if FCurrentToken = '/' then
    begin
      Advance;
      ResultFactor := ResultFactor / ParseFactor;
    end;
  end;
  Result := ResultFactor;
end;

function TArithmeticParser.ParseFactor: Extended;
begin
  if FCurrentToken = '(' then
  begin
    Advance;
    Result := ParseExpression;
    if FCurrentToken <> ')' then
      raise Exception.Create('Expected ")"');
    Advance;
  end
  else if ((FCurrentToken >= '0') and (FCurrentToken <= '9')) or (FCurrentToken = '.') then
  begin
    Result := ReadNumber;
  end
  else
    raise Exception.Create('Unexpected token: ' + FCurrentToken);
end;

function TArithmeticParser.Evaluate(const Input: string): Extended;
begin
  FInput := Input;
  FPosition := 1;
  SkipWhitespace;
  FCurrentToken := GetCurrentToken;
//  if FPosition <= Length(FInput) then
//    FCurrentToken := FInput[FPosition]
//  else
//    FCurrentToken := #0;
  Result := ParseExpression;
  if (FPosition <= Length(FInput)) and (FCurrentToken <> #0) then
  begin
    raise Exception.Create('Unexpected token: ' + FCurrentToken);
  end;
end;

end.
