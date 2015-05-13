set nocompatible " 关闭 vi 兼容模式
filetype on " 开启文件类型插件
filetype plugin on " 载入文件类型相关插件
filetype indent on " 为特定文件类型载入相关缩进文件
syntax enable " 显示语法高亮
syntax on " 开启文件类型语法检测
set number " 显示行号
set cursorline " 突出显示当前行
set ruler " 打开状态栏标尺
" set cursorcolumn " 打开纵向高亮对齐
set shiftwidth=4 " 设定 << 和 >> 命令移动时的宽度为 4
set softtabstop=4 " 使得按退格键时可以一次删掉 4 个空格
set tabstop=4 " 设定 tab 长度为 4
set nobackup " 覆盖文件时不备份
set autochdir " 自动切换当前目录为当前文件所在的目录
set backupcopy=yes " 设置备份时的行为为覆盖
set ignorecase smartcase " 搜索时忽略大小写，但在有一个或以上大写字母时仍保持对大小写敏感
set nowrapscan " 禁止在搜索到文件两端时重新搜索
set incsearch " 输入搜索内容时就显示搜索结果
set hlsearch " 搜索时高亮显示被找到的文本
set noerrorbells " 关闭错误信息响铃
set novisualbell " 关闭使用可视响铃代替呼叫
" set t_vb= " 置空错误铃声的终端代码
set showmatch " 插入括号时，短暂地跳转到匹配的对应括号
set matchtime=2 " 短暂跳转到匹配括号的时间
set magic " 设置魔术
set hidden " 允许在有未保存的修改时切换缓冲区，此时的修改由 vim 负责保存
" set guioptions-=T " 隐藏工具栏
" set guioptions-=m " 隐藏菜单栏
set smartindent " 开启新行时使用智能自动缩进
set backspace=indent,eol,start	" 不设定在插入状态无法用退格键和 Delete 键删除回车符
set cmdheight=1 " 设定命令行的行数为 1
set laststatus=2 " 显示状态栏 (默认值为 1, 无法显示状态栏)
set wildmenu " 使用命令行补全
set mouse=a " 在任意模式下支持鼠标点击定位
set completeopt=longest,menu " 支持自动补全
set scrolloff=4 " 光标移到buffer顶部或底部时保持4行距离(文本到达顶端或末尾时除外)
set iskeyword+=_,$,@,%,#,- " 带有这些字符的内容不被自动换行分割
set autoindent " 使用autoindent缩进结构，每一行的缩进与上一行类似
set cindent " 使用C语言风格的cindent缩进结构
set noexpandtab " 不要用空格代替制表符
set smarttab " 在行和段开始处使用制表符
set confirm " 处理只读或未保存文件时，弹出确认
set showcmd " 在命令栏右侧显示输入的命令
set linebreak " 使用整词换行


"--------------------------------------------------------------------------------------
"--- 设置语法折叠 ---
set foldenable " 开始折叠
set foldmethod=syntax " 设置语法折叠
set foldcolumn=0 " 设置折叠区域的宽度
setlocal foldlevel=99999999999999 " 设置折叠层数，设置为较大值则可默认关闭折叠
" set foldclose=all " 设置为自动关闭折叠
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR> " 用空格键来开关折叠


"--------------------------------------------------------------------------------------
"--- 括号自动补全 ---

"->定义括号补全函数
function! AutoPair(open, close)
	let line = getline('.')
	if col('.') > strlen(line) || line[col('.') - 1] == ' '
		return a:open.a:close."\<ESC>i"
	else
		return a:open
	endif
endf
function! ClosePair(char)
	if getline('.')[col('.') - 1] == a:char
		return "\<Right>"
	else
		return a:char
	endif
endf

"->设置补全模式
" 小括号的补全模式：只在行首与行尾进行补全，行中间不进行补全
" 花括号的补全方式：输入'{'后按快速按下回车键后会按照c语言格式进行括号补全，如果未快速按下回车键则不进行补全操作
" 其它符号则为简单的任意位置补全
:inoremap ( <c-r>=AutoPair('(', ')')<CR>
" :inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap {<CR> {<CR>}<Esc>O
" :inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<ESC>i
" :inoremap ] <c-r>=ClosePair(']')<CR>
:inoremap " ""<ESC>i
:inoremap ' ''<ESC>i


"--------------------------------------------------------------------------------------
"--- 解决中文跨平台乱码问题 ---
set termencoding=utf-8
set encoding=utf-8
let &termencoding=&encoding
set fileencodings=utf-8,gbk,gb2312,gb18030


"--------------------------------------------------------------------------------------
"--- Vundle插件管理器 ---
filetype off
set rtp+=~/.vim/bundle/Vundle.vim	" 设置Vundle插件的路径
call vundle#begin()

"->安装插件列表
Plugin 'gmarik/Vundle.vim' 		" let Vundle manage Vundle, required
Plugin 'Lokaltog/vim-powerline' 	" 来自github的vim插件，写成这样的格式
Plugin 'scrooloose/syntastic'		" 语法检测插件
Plugin 'fholgado/minibufexpl.vim'	
Plugin 'ervandew/supertab'
Plugin 'flazz/vim-colorschemes'		" vim主题配色集
" Plugin 'altercation/vim-colors-solarized'	" solarized主题配色插件
" Plugin 'ervandew/eclim'			" 类似eclipse的java插件
Plugin 'terryma/vim-multiple-cursors' 	" 多点编辑插件，选中目标后可以用ctrl+n键批量重构同名变量
Plugin 'Shougo/neocomplcache.vim'		" 补全插件
" Plugin 'Valloric/YouCompleteMe'			" 高级补全插件，支持语法补全
Plugin 'taglist.vim'			" 来自github中vim-scripts收集的插件直接写名字,不过很可能获得的是旧版本
Plugin 'winmanager--Fox'		" 窗口管理插件
call vundle#end()            	" required
filetype plugin indent on " 开启插件

"->Vundle常用指令
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
" :PluginUpdate		- update all the plugins which you have installed


"--------------------------------------------------------------------------------------
"--- WinManager配置 ---
let g:winManagerWindowLayout = "TagList|FileExplorer"		" 设置WinManager管理的插件
let g:winManagerWidth = 35									" 设置WinManager侧边栏的大小
let g:persistentBehaviour = 0								" 设置关闭所有文件时自动关闭WinManager
nmap wm :WMToggle<cr>										" 定义打开关闭WinManager快捷键为wm


"--------------------------------------------------------------------------------------
"--- Taglist 配置 ---
" nmap tl :TlistToggle<cr>	" 设置taglist的快捷键为tl。
" let Tlist_Use_Horiz_Window = 1	" 设置tag窗口横向显示
" let Tlist_Show_One_File = 1	" 不同时显示多个文件的tag，只显示当前文件的
" let Tlist_Auto_Open = 1	" 打开vim时自动打开tag窗口
let Tlist_Exit_OnlyWindow = 1	" 关闭vim时关闭tag窗口
let Tlist_Auto_Update = 1	" 默认更新taglist
" let Tlist_File_Fold_Auto_Close = 1	" 只显示当前文件的taglist，其它的taglist都被折叠
let Tlist_Show_Menu = 1		" 显示taglist菜单
" let Tlist_Use_SingleClick = 0	" 设置点击跳转tag的方式，0为双击跳转，1为单击跳转
" let Tlist_Use_Right_Window = 1	" 设置tag窗口靠右显示（默认窗口靠左）
" let Tlist_Process_File_Always = 1	" taglist始终解析文件中的tag，不管taglist窗口有没有打开


"--------------------------------------------------------------------------------------
"--- PowerLine配置 ---
let g:Powerline_symbols = 'unicode' 	" 指定powerline插件采用的特殊字符类型，共有三种，分别为compatible(无特殊字符)，unicode(简单特殊字符)，fancy(完整字符集，需要patch字体，包含图标样式)，建议采用unicode字符类型
let g:Powerline_stl_path_style = 'short' 	" 制定文件路径的显示方式
set t_Co=256	" 告知终端支持256色显示


"--------------------------------------------------------------------------------------
"--- neocomplcache配置 ---
let g:neocomplcache_enable_at_startup = 1  		" 在系统启动的时候启动neo  
let g:neocomplcache_enable_auto_select = 1 		" 提示的时候默认选择地一个，否则需要手动选取
let g:neocomplcache_enable_smart_case = 1		" 开启只能匹配
let g:neocomplcache_min_syntax_length = 3		" 设置最小匹配长度
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
let g:neocomplcache_enable_cursor_hold_i = 1		" 在输入模式下，移动光标时不会触发补全菜单
let g:neocomplcache_enable_insert_char_pre = 1		" 快速匹配先前输入的内容，加快匹配速度
let g:neocomplcache_enable_auto_select = 1		" 默认补全光标自动开启

"->定义补全字典
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

"->定义补全关键字
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

"->ctrl+z撤销已补全的内容再次匹配，ctrl+j主动弹出补全菜单
inoremap <expr><C-z>     neocomplcache#undo_completion()		
inoremap <expr><C-j>     neocomplcache#complete_common_string()

"->启动vim自带的omni补全
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

"->使用重度omni补全特性
if !exists('g:neocomplcache_force_omni_patterns')
  let g:neocomplcache_force_omni_patterns = {}
endif
let g:neocomplcache_force_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_force_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
let g:neocomplcache_force_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'


"--------------------------------------------------------------------------------------
"--- syntastic配置 ---
let g:syntastic_check_on_open = 1		" 首次打开文件时即开始检测语法错误
let g:syntastic_error_symbol = "✗"		" 设置语法错误的提示
let g:syntastic_warning_symbol = "⚠"	" 设置语法警告的提示
let g:syntastic_cpp_compiler_options = "-std=c++1y"		" 检测c++语法时支持c++1y的新特性
let g:syntastic_ignore_files = [".*\.m$"]	" 忽略Objective-C语言的语法检测(objc的检测体验很差)


"--------------------------------------------------------------------------------------
"--- 常用的几个主题 ---
" colorscheme darkzen
" colorschem matrix
" colorschem zenburn
" colorscheme muon
colorscheme koehler
