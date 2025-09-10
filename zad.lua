script_name("zad")
script_version("beta_v1.8")

require "lib.moonloader"

local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil

local trstl1 = {['ph'] = '�',['Ph'] = '�',['Ch'] = '�',['ch'] = '�',['Th'] = '�',['th'] = '�',['Sh'] = '�',['sh'] = '�', ['ea'] = '�',['Ae'] = '�',['ae'] = '�',['size'] = '����',['Jj'] = '��������',['Whi'] = '���',['whi'] = '���',['Ck'] = '�',['ck'] = '�',['Kh'] = '�',['kh'] = '�',['hn'] = '�',['Hen'] = '���',['Zh'] = '�',['zh'] = '�',['Yu'] = '�',['yu'] = '�',['Yo'] = '�',['yo'] = '�',['Cz'] = '�',['cz'] = '�', ['ia'] = '�', ['ea'] = '�',['Ya'] = '�', ['ya'] = '�', ['ove'] = '��',['ay'] = '��', ['rise'] = '����',['oo'] = '�', ['Oo'] = '�'}
local trstl = {['B'] = '�',['Z'] = '�',['T'] = '�',['Y'] = '�',['P'] = '�',['J'] = '��',['X'] = '��',['G'] = '�',['V'] = '�',['H'] = '�',['N'] = '�',['E'] = '�',['I'] = '�',['D'] = '�',['O'] = '�',['K'] = '�',['F'] = '�',['y`'] = '�',['e`'] = '�',['A'] = '�',['C'] = '�',['L'] = '�',['M'] = '�',['W'] = '�',['Q'] = '�',['U'] = '�',['R'] = '�',['S'] = '�',['zm'] = '���',['h'] = '�',['q'] = '�',['y'] = '�',['a'] = '�',['w'] = '�',['b'] = '�',['v'] = '�',['g'] = '�',['d'] = '�',['e'] = '�',['z'] = '�',['i'] = '�',['j'] = '�',['k'] = '�',['l'] = '�',['m'] = '�',['n'] = '�',['o'] = '�',['p'] = '�',['r'] = '�',['s'] = '�',['t'] = '�',['u'] = '�',['f'] = '�',['x'] = 'x',['c'] = '�',['``'] = '�',['`'] = '�',['_'] = ' '}

local mysql = require "luasql.mysql"
local env = assert(mysql.mysql())
local conn = assert(env:connect("arizona", "longames", "q2w3e4r5", "92.63.71.249", 3306))
local ImGui                         = require 'imgui'
local sampev                        = require "lib.samp.events"
local requests                      = require 'requests'
local ffi                           = require('ffi')

local encoding                      = require 'encoding'
encoding.default                    = "CP1251"
local u8                            = encoding.UTF8
local effil_check, effil            = pcall(require, 'effil')
ffi.cdef 'void __stdcall ExitProcess(unsigned int)'
local check_update = true

math.randomseed(os.time())

function main()

    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(0) end
    
    if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end

    sampAddChatMessage('', -1)
    sampAddChatMessage('', -1)
    sampAddChatMessage('{AFEEEE}������ ������ � ����������� ��������� {FFA500}������� ��������', -1)
    sampAddChatMessage('{AFEEEE}������� ��� �������� ����: {FFA500}/zad', -1)
    sampAddChatMessage('{00FFFF}����������: {FFA500}Irin_Crown', -1)
    sampAddChatMessage('', -1)
    sampAddChatMessage('', -1)

    sampRegisterChatCommand('zad', zadmenu)
    sampRegisterChatCommand('upd', upd)
    
    while true do
        wait(0)
        local result, button, list, input = sampHasDialogRespond(1000)
        if result then
            if button == 1 and list == 0 then                                                                                           -- �������� �������
                zad()
                while sampIsDialogActive(1001) do wait(100) end
                local result, button, list, input = sampHasDialogRespond(1001)

                if button == 1 and list == 0 then                                                                                       -- �������: ������ �������
                    inputnick()
                    while sampIsDialogActive(2008) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2008)

                    if button == 1 then
                        local nick = input

                        praisecount()
                        while sampIsDialogActive(2011) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2011)                        

                        if button == 1 then
                            local prisecount = input

                            inputreason()
                            while sampIsDialogActive(2002) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2002)

                            if button == 1 then
                                local reason = input
                                local zadanie = ('������ ������� '..nick)
                                for i = 1, prisecount do
                                    local test = assert(conn:execute("SELECT COUNT(*) AS 'cnt' FROM zadlist"))
                                    local rowd = test:fetch({}, "a")
                                    local num = rowd.cnt
                                    local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                    local autor = sampGetPlayerNickname(who_id)
                                    local command = ('/praise '..nick.. ' '..reason)

                                    assert(conn:execute("INSERT INTO zadlist (id,name,nick,command,reason,status,autor) VALUES ('"..num.."','"..zadanie.."', '"..nick.."', '"..command.."','"..reason.."','1','"..autor.."')"))
                                    sampAddChatMessage('��������� �������: {ffbf00}'..zadanie, -1)
                                end
                            end
                        end
                    end
                end

                if button == 1 and list == 1 then                                                                                       -- �������: �������� ����������
                    inputnick()
                    while sampIsDialogActive(2008) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2008)

                    if button == 1 then
                        local nick = input
                        local zadanie = ('������ ��������� '..nick)

                        ranklist()
                        while sampIsDialogActive(2007) do wait(100) end
                        local result, button, list, input = sampHasDialogRespond(2007)
                        
                        if button == 1 then
                            local rank = list+1

                            inputreason()
                            while sampIsDialogActive(2005) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2005)
                            
                            if button == 1 then
                                local reason = input

                                local test = assert(conn:execute("SELECT COUNT(*) AS 'cnt' FROM zadlist"))
                                local rowd = test:fetch({}, "a")
                                local num = rowd.cnt
                                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                local autor = sampGetPlayerNickname(who_id)
                                local command = ('/giverank '..nick.. ' '..rank)

                                assert(conn:execute("INSERT INTO zadlist (id,name,nick,command,reason,status,autor) VALUES ('"..num.."','"..zadanie.."', '"..nick.."', '"..command.."','"..reason.."','1','"..autor.."')"))
                                sampAddChatMessage('��������� �������: {ffbf00}'..zadanie, -1)
                            end
                        end
                    end
                end

                if button == 1 and list == 2 then                                                                                       -- �������: ������� � �����������
                    inputnick()
                    while sampIsDialogActive(2008) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2008)

                    if button == 1 then
                        local nick = input
                        local zadanie = ('������� � ����������� '..nick..' �� 4�� ����')

                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)
                            
                        if button == 1 then
                            local reason = input
                            local test = assert(conn:execute("SELECT COUNT(*) AS 'cnt' FROM zadlist"))
                            local rowd = test:fetch({}, "a")
                            local num = rowd.cnt
                            local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                            local autor = sampGetPlayerNickname(who_id)
                            local command = ('/invite '..nick)

                            assert(conn:execute("INSERT INTO zadlist (id,name,nick,command,reason,status,autor) VALUES ('"..num.."','"..zadanie.."', '"..nick.."', '"..command.."','"..reason.."','1','"..autor.."')"))
                            sampAddChatMessage('��������� �������: {ffbf00}'..zadanie, -1)
                        end
                    end
                end

                if button == 1 and list == 3 then                                                                                       -- �������: ������ �����
                    inputnick()
                    while sampIsDialogActive(2008) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2008)

                    if button == 1 then
                        local nick = input
                        local zadanie = ('������ ����� '..nick)

                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)

                        if button == 1 then
                            local reason = input

                            settag()
                            while sampIsDialogActive(2020) do wait(100) end
                            local result, button, list, input = sampHasDialogRespond(2020)

                            if button == 1 and list == 0 then
                                local tagname = string.gsub(string.match(nick, "_%a+"), "_", "")
                                tag = 'TD | '..tagname
                            end

                            if button == 1 and list == 1 then
                                local tagname = string.gsub(string.match(nick, "_%a+"), "_", "")
                                tag = 'ID | '..tagname
                            end

                            if button == 1 and list == 2 then
                                local tagname = string.gsub(string.match(nick, "_%a+"), "_", "")
                                tag = 'DA | '..tagname
                            end

                            local test = assert(conn:execute("SELECT COUNT(*) AS 'cnt' FROM zadlist"))
                            local rowd = test:fetch({}, "a")
                            local num = rowd.cnt
                            local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                            local autor = sampGetPlayerNickname(who_id)
                            local command = ('/settag '..nick..' '..tag)

                            assert(conn:execute("INSERT INTO zadlist (id,name,nick,command,reason,status,autor) VALUES ('"..num.."','"..zadanie.."', '"..nick.."', '"..command.."','"..reason.."','1','"..autor.."')"))
                            sampAddChatMessage('��������� �������: {ffbf00}'..zadanie, -1)
                        end
                    end
                end

                if button == 1 and list == 4 then                                                                                       -- �������: ������ �������
                    inputnick()
                    while sampIsDialogActive(2008) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2008)

                    if button == 1 then
                        local nick = input
                        local zadanie = ('������ ������� '..nick)

                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)

                        if button == 1 then
                            local reason = input
                            local test = assert(conn:execute("SELECT COUNT(*) AS 'cnt' FROM zadlist"))
                            local rowd = test:fetch({}, "a")
                            local num = rowd.cnt
                            local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                            local autor = sampGetPlayerNickname(who_id)
                            local command = ('/fwarn '..nick..' '..reason)

                            assert(conn:execute("INSERT INTO zadlist (id,name,nick,command,reason,status,autor) VALUES ('"..num.."','"..zadanie.."', '"..nick.."', '"..command.."','"..reason.."','1','"..autor.."')"))
                            sampAddChatMessage('��������� �������: {ffbf00}'..zadanie, -1)
                        end
                    end
                end

                if button == 1 and list == 5 then                                                                                       -- �������: ������� �� �����������
                    inputnick()
                    while sampIsDialogActive(2008) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2008)

                    if button == 1 then
                        local nick = input
                        local zadanie = ('������� �� ����������� '..nick)

                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)

                        if button == 1 then
                            local reason = input
                            local test = assert(conn:execute("SELECT COUNT(*) AS 'cnt' FROM zadlist"))
                            local rowd = test:fetch({}, "a")
                            local num = rowd.cnt
                            local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                            local autor = sampGetPlayerNickname(who_id)
                            local command = ('/uninvite '..nick..' '..reason)

                            assert(conn:execute("INSERT INTO zadlist (id,name,nick,command,reason,status,autor) VALUES ('"..num.."','"..zadanie.."', '"..nick.."', '"..command.."','"..reason.."','1','"..autor.."')"))
                            sampAddChatMessage('��������� �������: {ffbf00}'..zadanie, -1)
                        end
                    end
                end

                if button == 1 and list == 6 then                                                                                       -- �������: ������� � ������ ������
                    inputnick()
                    while sampIsDialogActive(2008) do wait(100) end
                    local result, button, _, input = sampHasDialogRespond(2008)

                    if button == 1 then
                        local nick = input
                        local zadanie = ('������� � �� ����������� '..nick)

                        inputreason()
                        while sampIsDialogActive(2005) do wait(100) end
                        local result, button, _, input = sampHasDialogRespond(2005)

                        if button == 1 then
                            local reason = input
                            local test = assert(conn:execute("SELECT COUNT(*) AS 'cnt' FROM zadlist"))
                            local rowd = test:fetch({}, "a")
                            local num = rowd.cnt
                            local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                            local autor = sampGetPlayerNickname(who_id)
                            local command = ('/blacklist '..nick..' '..reason)

                            assert(conn:execute("INSERT INTO zadlist (id,name,nick,command,reason,status,autor) VALUES ('"..num.."','"..zadanie.."', '"..nick.."', '"..command.."','"..reason.."','1','"..autor.."')"))
                            sampAddChatMessage('��������� �������: {ffbf00}'..zadanie, -1)
                        end
                    end
                end

                local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                local row = cursor:fetch({}, "a")
                local cnt = 0
                while row do
                    assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                    row = cursor:fetch({}, "a")
                    cnt = cnt+1
                end

                if button == 0 then
                    zadmenu()
                end
            end

            if button == 1 and list == 1 then                                                                                                       -- ��������� �������
                local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by id DESC"))
                local row = cursor:fetch({}, "a")
                local list = ''
                local cnt = 0
                
                while row do
                    cnt = cnt+1
                    list = '['..row.id..'] '..row.name..'\n'..list
                    row = cursor:fetch({}, "a")
                end

                zadlist(logo, list)
                while sampIsDialogActive(9999) do wait(100) end
                local result, button, list, input = sampHasDialogRespond(9999)

                for i=0, cnt-1  do
                    if button == 1 and list == i then
                        local cursor = assert(conn:execute("SELECT * FROM zadlist WHERE id = '"..i.."'"))
                        local row = cursor:fetch({}, "a")

                        if row.name:match('�������') then                                                                                            -- ���� ��������� �������: ������ �������
                            local time = os.date('%H:%M:%S', os.time() - (4 * 3600))
                            local date = os.date('%d.%m.%Y')
                            local datetime = (date..' '..time)
                            local id = sampGetPlayerIdByNickname(row.nick)
                            local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                            local who_nick = sampGetPlayerNickname(who_id)
                            local who_add = (who_nick..' ['..who_id..']')

                            assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                            assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))
                            
                            sampProcessChatInput("/praise "..id.." "..row.reason,-1)
                            sampProcessChatInput('/time ',-1)

                            sampAddChatMessage('�������: {ffad33}'..row.name..' {FFFFFF}���������', -1)

                            info_2 = ('������ �������. \n\n���������: '..row.nick.. ' ['..id..'] \n���� ������: '..date..' \n����� ������: '..time..'\n���������� �������: 1\n�������: '..row.reason..'\n\n������ �������: '..row.autor..'\n��������: '..who_nick..' ['..who_id..']')
                            img = 'photo-232454643_456239040'
                            sendvkimg(encodeUrl(info_2),img)

                            local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                            local row = cursor:fetch({}, "a")
                            local cnt = 0
                            while row do
                                assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                row = cursor:fetch({}, "a")
                                cnt = cnt+1
                            end
                        end

                        if row.name:match('���������') then                                                                                           -- ���� ��������� �������: ������ ���������
                            local time = os.date('%H:%M:%S', os.time() - (4 * 3600))
                            local date = os.date('%d.%m.%Y')
                            local datetime = (date..' '..time)
                            local id = sampGetPlayerIdByNickname(row.nick)
                            local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                            local who_nick = sampGetPlayerNickname(who_id)
                            local who_add = (who_nick..' ['..who_id..']')

                            --assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                            assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))
                            
                            sampProcessChatInput(row.command,-1)
                            sampProcessChatInput('/time ',-1)

                            sampAddChatMessage('�������: {ffad33}'..row.name..' {FFFFFF}���������', -1)

                            info_2 = ('������ ���������. \n\n���������: '..row.nick.. ' ['..id..'] \n���� ���������: '..date..' \n����� ���������: '..time..'\n�������: '..row.reason..'\n\n������ �������: '..row.autor..'\n��������: '..who_nick..' ['..who_id..']')
                            img = 'photo-232454643_456239038'
                            sendvkimg(encodeUrl(info_2),img)

                            local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                            local row = cursor:fetch({}, "a")
                            local cnt = 0
                            while row do
                                assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                row = cursor:fetch({}, "a")
                                cnt = cnt+1
                            end
                        end

                        if row.name:match('�������') then                                                                                            -- ���� ��������� �������: ������� � �����������
                            local time = os.date('%H:%M:%S', os.time() - (4 * 3600))
                            local date = os.date('%d.%m.%Y')
                            local datetime = (date..' '..time)
                            local id = sampGetPlayerIdByNickname(row.nick)
                            local nick = row.nick 
                            local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                            local who_nick = sampGetPlayerNickname(who_id)
                            local who_add = (who_nick..' ['..who_id..']')
                            local nm = trst(nick)

                            sampProcessChatInput('/do ����� � ������ �� �����.',-1)
                            wait(1000)
                            sampProcessChatInput('/me ������� ����� �� ��� � ���������',-1)
                            wait(1000)
                            sampProcessChatInput('/do ����� � �������� ���� ����� �� ����.',-1)
                            wait(1000)
                            sampProcessChatInput('/me ���� ����� � ������� �������� ��������',-1)
                            wait(1000)
                            sampProcessChatInput(row.command,-1)
                            wait(1000)
                            sampProcessChatInput('/time ',-1)
                            wait(2000)
                            waitrp(id, nick)
                            while sampIsDialogActive(2004) do wait(100) end
                            local result, button, _, input = sampHasDialogRespond(2004)
                            if button == 1 then
                                assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                                assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))

                                sampProcessChatInput('/fractionrp '..id,-1)
                                wait(2000)
                                sampProcessChatInput('/r ������������ ������ ���������� ��������� ������������ - '..nm..'.',-1)
                                wait(2000)
                                sampProcessChatInput('/time ',-1)
                                wait(2000)
                                sampProcessChatInput('/do �� ����� ��������� ���.', -1)
                                wait(1000)
                                sampProcessChatInput('/me ������� ��� � ����� � �������� ������ �������� ���', -1)
                                wait(1000)
                                sampProcessChatInput('/me ������� � ���� ����������� � ������ ���������, ����� ���� ������ ��� ������� �� ����', -1)
                                wait(1000)
                                sampProcessChatInput('/giverank '..id..' 4', -1)
                                wait(1000)
                                sampProcessChatInput('/r ��������� '..nm..' ������� ����� ��������� - ��������.', -1)
                                wait(2000)
                                sampProcessChatInput('/time', -1)

                                info_2 = ('�������� � �����������. \n\n���������: '..row.nick.. ' ['..id..'] \n���� ��������: '..date..' \n����� ��������: '..time..'\n�������: '..row.reason..'\n\n������ �������: '..row.autor..'\n��������: '..who_nick..' ['..who_id..']')
                                img = 'photo-232454643_456239037'
                                sendvkimg(encodeUrl(info_2),img)

                                local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                                local row = cursor:fetch({}, "a")
                                local cnt = 0
                                while row do
                                    assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                    row = cursor:fetch({}, "a")
                                    cnt = cnt+1
                                end
                            end
                        end

                        if row.name:match('�����') then                                                                                              -- ���� ��������� �������: ������ �����
                            local time = os.date('%H:%M:%S', os.time() - (4 * 3600))
                            local date = os.date('%d.%m.%Y')
                            local datetime = (date..' '..time)
                            local id = sampGetPlayerIdByNickname(row.nick)
                            local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                            local who_nick = sampGetPlayerNickname(who_id)
                            local who_add = (who_nick..' ['..who_id..']')

                            --assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                            assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))
                            
                            sampProcessChatInput(row.command,-1)
                            sampProcessChatInput('/time ',-1)

                            sampAddChatMessage('�������: {ffad33}'..row.name..' {FFFFFF}���������', -1)

                            info_2 = ('������ �����. \n\n���������: '..row.nick.. ' ['..id..'] \n���� ����������: '..date..' \n����� ����������: '..time..'\n�������: '..row.reason..'\n\n������ �������: '..row.autor..'\n��������: '..who_nick..' ['..who_id..']')
                            img = 'photo-232454643_456239038'
                            sendvkimg(encodeUrl(info_2),img)

                            local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                            local row = cursor:fetch({}, "a")
                            local cnt = 0
                            while row do
                                assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                row = cursor:fetch({}, "a")
                                cnt = cnt+1
                            end
                        end

                        if row.name:match('�������') then                                                                                            -- ���� ��������� �������: ������ �������
                            local time = os.date('%H:%M:%S', os.time() - (4 * 3600))
                            local date = os.date('%d.%m.%Y')
                            local datetime = (date..' '..time)
                            local id = sampGetPlayerIdByNickname(row.nick)
                            local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                            local who_nick = sampGetPlayerNickname(who_id)
                            local who_add = (who_nick..' ['..who_id..']')

                            --assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                            assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))
                            
                            sampProcessChatInput(row.command,-1)
                            sampProcessChatInput('/time ',-1)

                            sampAddChatMessage('�������: {ffad33}'..row.name..' {FFFFFF}���������', -1)

                            info_2 = ('������ ��������. \n\n���������: '..row.nick.. ' ['..id..'] \n���� ��������: '..date..' \n����� ��������: '..time..'\n�������: '..row.reason..'\n\n������ �������: '..row.autor..'\n��������: '..who_nick..' ['..who_id..']')
                            img = 'photo-232454643_456239035'
                            sendvkimg(encodeUrl(info_2),img)

                            local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                            local row = cursor:fetch({}, "a")
                            local cnt = 0
                            while row do
                                assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                row = cursor:fetch({}, "a")
                                cnt = cnt+1
                            end
                        end

                        if row.name:match('�������') then                                                                                            -- ���� ��������� �������: ������� �� �����������
                            local time = os.date('%H:%M:%S', os.time() - (4 * 3600))
                            local date = os.date('%d.%m.%Y')
                            local datetime = (date..' '..time)
                            local id = sampGetPlayerIdByNickname(row.nick)
                            local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                            local who_nick = sampGetPlayerNickname(who_id)
                            local who_add = (who_nick..' ['..who_id..']')

                            --assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                            assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))
                            
                            sampProcessChatInput(row.command,-1)
                            sampProcessChatInput('/time ',-1)

                            sampAddChatMessage('�������: {ffad33}'..row.name..' {FFFFFF}���������', -1)

                            info_2 = ('���������� �� ����������� �����. \n\n���������: '..row.nick.. ' ['..id..'] \n���� ����������: '..date..' \n����� ����������: '..time..'\n�������: '..row.reason..'\n\n������ �������: '..row.autor..'\n��������: '..who_nick..' ['..who_id..']')
                            img = 'photo-232454643_456239045'
                            sendvkimg(encodeUrl(info_2),img)

                            local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                            local row = cursor:fetch({}, "a")
                            local cnt = 0
                            while row do
                                assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                row = cursor:fetch({}, "a")
                                cnt = cnt+1
                            end
                        end

                        if row.name:match('������') then                                                                                             -- ���� ��������� �������: ������ � ������ ������
                            local time = os.date('%H:%M:%S', os.time() - (4 * 3600))
                            local date = os.date('%d.%m.%Y')
                            local datetime = (date..' '..time)
                            local id = sampGetPlayerIdByNickname(row.nick)
                            local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                            local who_nick = sampGetPlayerNickname(who_id)
                            local who_add = (who_nick..' ['..who_id..']')

                            --assert(conn:execute("DELETE FROM zadlist WHERE id = '"..row.id.."'"))
                            assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick, autor) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '"..row.command.."', '"..row.reason.."', '"..row.nick.."', '"..row.autor.."')"))
                            
                            sampProcessChatInput(row.command,-1)
                            sampProcessChatInput('/time ',-1)

                            sampAddChatMessage('�������: {ffad33}'..row.name..' {FFFFFF}���������', -1)

                            info_2 = ('�������� � ������ ������. \n\n���������: '..row.nick.. ' ['..id..'] \n���� ��������: '..date..' \n����� ��������: '..time..'\n�������: '..row.reason..'\n\n������ �������: '..row.autor..'\n��������: '..who_nick..' ['..who_id..']')
                            img = 'photo-232454643_456239046'
                            sendvkimg(encodeUrl(info_2),img)

                            local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                            local row = cursor:fetch({}, "a")
                            local cnt = 0
                            while row do
                                assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                                row = cursor:fetch({}, "a")
                                cnt = cnt+1
                            end
                        end
                    end
                end

                if button == 0 then
                    zadmenu()
                end
            end

            if button == 1 and list == 2 then                                                                                                       -- �������� �������
                local time = os.date('%H:%M:%S', os.time() - (4 * 3600))
                local date = os.date('%d.%m.%Y')
                local datetime = (date..' '..time)
                local _, who_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                local who_nick = sampGetPlayerNickname(who_id)
                local who_add = (who_nick..' ['..who_id..']')

                local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by id DESC"))
                local row = cursor:fetch({}, "a")
                local list = ''
                local cnt = 0
                
                while row do                                                                                 
                    cnt = cnt+1
                    list = '['..row.id..'] '..row.name..'\n'..list
                    row = cursor:fetch({}, "a")
                end

                zadlist(logo, list)
                while sampIsDialogActive(9999) do wait(100) end
                local result, button, list, input = sampHasDialogRespond(9999)

                for i=0, cnt-1  do
                    if button == 1 and list == i then
                        
                        local cursor = assert(conn:execute("SELECT * FROM zadlist WHERE id = '"..i.."'"))
                        local row = cursor:fetch({}, "a")
                        while row do
                            --assert(conn:execute("INSERT INTO history (datetime, who_nick, zadanie, command, reason, nick) VALUES ('"..datetime.."', '"..who_add.."', '"..row.name.."', '-', '-', '-')"))
                            assert(conn:execute("DELETE FROM zadlist WHERE id = '"..i.."'"))
                            row = cursor:fetch({}, "a")
                        end
                        
                        local cursor = assert(conn:execute("SELECT * FROM zadlist ORDER by uid ASC"))
                        local row = cursor:fetch({}, "a")
                        local cnt = 0
                        while row do
                            assert(conn:execute("UPDATE zadlist SET id = '"..cnt.."' WHERE uid = '"..row.uid.."'"))
                            row = cursor:fetch({}, "a")
                            cnt = cnt+1
                        end

                        sampAddChatMessage('������� �������',-1)
                    end
                end

                if button == 0 then
                    zadmenu()
                end
            end

            if button == 1 and list == 4 then                                                                                                       -- ������� ����������
                local cursor = assert(conn:execute("SELECT * FROM history ORDER by uid ASC"))
                local row = cursor:fetch({}, "a")
                info = ''

                while row do
                    info = '{87CEFA}'..row.datetime.. ' {FF8C00}' ..row.who_nick.. ' {87CEFA}�������� �������: {FF8C00}'..row.zadanie..' {87CEFA}�������: {FF8C00}'..row.reason..' {87CEFA}| {FF8C00}'..row.autor..' \n'..info
                    row = cursor:fetch({}, "a")
                end

                sampShowDialog(0, "{FFA500}������� ������ � ���������", info, "�������", "", DIALOG_STYLE_MSGBOX)
                while sampIsDialogActive(0) do wait(100) end
                local result, button, _, input = sampHasDialogRespond(0)

                if button == 0 or button == 1 then
                    zadmenu()
                end
            end

            if button == 0 then
                sampCloseCurrentDialogWithButton(0)
            end
        end
        if check_update then
            if check_update then
                --lua_thread.create(function()
                    upd()
                    wait(60000)
                --end)
            end
        end
    end
end

function zadlist(logo,data)
    sampShowDialog(9999, logo, data, '�������', '������', 2)
end

function zadmenu()
    sampShowDialog(1000, "{FFA500}���� ������� �������������", '�������� �������\n������ ������� �� ����������\n������� �������\n \n������� ����������', '�������', '������', 2)
end

function zad()
    sampShowDialog(1001, "�������� ������� � �������", "������ �������\n�������� ����������\n������� � �����������\n���������� �����\n������ �������\n������� �� �����������\n������� � �� ���", '�������', '������', 2)
end

function inputnick()
    sampShowDialog(2008, "���� ����� ����", "������� ���: ", '�������', '������', 1)
end

function praisecount()
    sampShowDialog(2011, "{FFA500}������ ������� ������", "������� �������� ������ ��� ������", "������", "������", 1)
end

function inputreason()
    sampShowDialog(2005, "{FFA500}�������� �������:", "������� �������:", "������", "������", 1)
end

function ranklist()
    sampShowDialog(2007, "{FFA500}���������", string.format("[1] ������\n[2] ������� ������\n[3] ������� ��������\n[4] ��������\n[5] ������� ��������\n[6] �������� ���������\n[7] ���������\n[8] �������"), "�������", "������", 2)
end

function settag()
    sampShowDialog(2020, "{FFA500}���������� ����� ������", "[TD] Tactical Department\n[ID] Inspection Department\n[DA] Department of Assistance\n[����� ���] ������� ���", "������", "������", 2)
end

function waitrp(id, nick)
    sampShowDialog(2004, "{FFA500}������������� RP", "{78dbe2}����� ����, ��� ����� {ffa000}"..nick.." ["..id.."]\n{78dbe2}������� � �����������, ������� ���������� ����� ��������� �� ���������", "����������", "������", DIALOG_STYLE_MSGBOX)
end

function sampGetPlayerIdByNickname(nick)
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    if tostring(nick) == sampGetPlayerNickname(myid) then return myid end
    for i = 0, 1000 do if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == tostring(nick) then return i end end
        return -1
end

function threadHandle(runner, url, args, resolve, reject) -- ��������� effil ������ ��� ����������
    local t = runner(url, args)
    local r = t:get(0)
    while not r do
        r = t:get(0)
        wait(0)
    end
    local status = t:status()
    if status == 'completed' then
        local ok, result = r[1], r[2]
        --if ok then resolve(result) else reject(result) end
    elseif err then
        reject(err)
    elseif status == 'canceled' then
        reject(status)
    end
    t:cancel(0)
end

function requestRunner() -- �������� effil ������ � �������� https �������
    return effil.thread(function(u, a)
        local https = require 'ssl.https'
        local ok, result = pcall(https.request, u, a)
        if ok then
            return {true, result}
        else
            return {false, result}
        end
    end)
end

function async_http_request(url, args, resolve, reject)
    local runner = requestRunner()
    if not reject then reject = function() end end
    lua_thread.create(function()
        threadHandle(runner, url, args, resolve, reject)
    end)
end

function loop_async_http_request(url, args, reject)
    local runner = requestRunner()
    if not reject then reject = function() end end
    lua_thread.create(function()
        while true do
            while not key do wait(0) end
            url = server .. '?act=a_check&key=' .. key .. '&ts=' .. ts .. '&wait=25' --������ url ������ ����� ������ �����a, ��� ��� server/key/ts ����� ����������
            threadHandle(runner, url, args, longpollResolve, reject)
        end
    end)
end

function sendvkimg(msg,img)
    local rnd = math.random(-2147483648, 2147483647)
    local peer_id = 2000000002
    local token2 = 'vk1.a.5MHxEjL9XhlKr4tWm_zjzke1IM86jlBC3UrZdFGQbHAD05Xteuc2cohwaUKQN3wcw8bgXJRm1o7tGc0u2qVUbVZPbAdIQaRoCp1gmQIf0Z8d3FX_3iZswg7qF8mcAWIlTrgHr5D9xtPUaTw5h3CAyxT8Dqcs20_z1lXiUCtSLHa4-teHPO7rozXirKy_B6gnBMAAqFunjb5k_R5ai60Xmg'
    local test = 'photo-232454643_456239019'
    async_http_request('https://api.vk.com/method/messages.send', 'peer_id='..peer_id..'&random_id=' .. rnd .. '&message='..msg..'&attachment='..img..'&access_token='..token2..'&v=5.81')
end

function encodeUrl(str)
   str = str:gsub(' ', '%+')
   str = str:gsub('\n', '%%0A')
   return u8:encode(str, 'CP1251')
end

function trst(name)
if name:match('%a+') then
        for k, v in pairs(trstl1) do
            name = name:gsub(k, v) 
        end
        for k, v in pairs(trstl) do
            name = name:gsub(k, v) 
        end
        return name
    end
 return name
end

function upd()
   local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'���������� ����������. ������� ���������� c '..thisScript().version..' �� '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('��������� %d �� %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then 
                                                            sampShowDialog(0, "{FFA500}����� ����������", "{78dbe2}������ ��� ������������� ��������.", "�������", "", DIALOG_STYLE_MSGBOX)
                                                            print('�������� ���������� ���������.')sampAddChatMessage(b..'���������� ���������!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'���������� ������ ��������. �������� ���������� ������..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': ���������� �� ���������.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, ������� �� �������� �������� ����������. ��������� ��� ��������� �������������� �� '..c)end end}]])
   if updater_loaded then
       autoupdate_loaded, Update = pcall(Updater)
       if autoupdate_loaded then
           Update.json_url = "https://raw.githubusercontent.com/ArtemyevaIA/zad/refs/heads/main/zad.json?" .. tostring(os.clock())
           Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
           Update.url = "https://github.com/ArtemyevaIA/zad"
       end

   end
   if autoupdate_loaded and Update then
       pcall(Update.check, Update.json_url, Update.prefix, Update.url)
   end 
end