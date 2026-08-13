# GDScript Interfaces（GDSS 接口插件）

> ### 🐋AI生成内容披露
> 该脚本由AI生成。

为 GDScript 提供 **Java 风格接口**支持的纯 GDScript 插件（无 C#、无引擎修改）。
已有脚本**无需任何改动**即可被接口系统识别（纯鸭子类型契约）。

## 特性

- **契约检查**：`IHealth.is_implemented_by(obj)` / `GSInterface.is_a(obj, IHealth)` —— 输入类名、接口名都能判断
- **静态类型调用零警告**：`var h := IHealth.of(obj)` 后 `h.take_damage(5)`、`h.max_health` 均不触发
  `unsafe_method_access` / `unsafe_property_access` 等任何警告
- **接口继承接口**：子接口契约 = 父接口全部方法/属性 + 自身新增
- **运行时契约强制**：调用未实现的方法/属性会立即报出清晰的契约违反错误
- **属性契约**：接口可声明属性（getter/setter 转发），读写直达目标对象
- **视图自动解包**：对视图做检查时自动还原真实目标；`IHealth.of(obj) is IHealth` 原生成立
- 定义/使用接口**只靠写脚本**，无需动节点检查器、无需改已有脚本、无需改引擎

## 快速上手

```gdscript
# 1) 定义接口（新脚本）：addons 之外任意位置，如 res://scripts/interfaces/i_health.gd
class_name IHealth
extends GSInterface

func take_damage(amount: int) -> void:
	_forward(&"take_damage", [amount])

func get_health() -> int:
	return _forward(&"get_health", [])

var max_health: int:
	get:
		return _pget(&"max_health")
	set(value):
		_pset(&"max_health", value)

static func of(obj) -> IHealth:
	return GSInterface.make_view(IHealth, obj)

static func is_implemented_by(obj: Object) -> bool:
	return GSInterface.implements(obj, IHealth)

# 2) 使用（任意已有/新脚本，无需继承接口）：
var h := IHealth.of(some_node)        # 视图：真 IHealth 实例，轻量包装壳
h.take_damage(5)                      # 零警告，运行时转发到 some_node.take_damage
print(h.get_health(), h.max_health)   # 属性同样转发
h.max_health = 999                    # 写入直达目标

if IHealth.is_implemented_by(some_node):   # 契约检查（等价写法：GSInterface.is_a(some_node, IHealth)）
	print("是 IHealth")
```

## API 参考（基类 `GSInterface`）

| 成员 | 说明 |
| --- | --- |
| `static implements(obj, iface)` | 鸭子契约检查：obj 实现 iface 声明的全部实例方法+属性（含父接口）。视图自动解包 |
| `static is_a(obj, type)` | 统一判断：type 可为脚本/接口引用（`IHealth`）、原生类名（`"Node2D"`）、全局类名字符串（尽力而为）。名义类型优先，接口按结构化契约 |
| `static call_method(obj, method, args)` | 不建视图的动态调用辅助（返回 Variant） |
| `static make_view(iface, obj)` | 视图工厂（接口的 `of()` 内部使用） |
| `func _forward(method, args)` | 方法转发（接口桩体用） |
| `func _pget(prop)` / `_pset(prop, value)` | 属性转发（接口属性 getter/setter 体用） |
| `var _target` | 视图持有的目标对象 |

## 接口定义模板

```gdscript
class_name IMyInterface
extends GSInterface

# 契约方法：桩体一行转发，签名即契约
func some_method(a: int) -> String:
	return _forward(&"some_method", [a])

# 契约属性（可选）
var some_prop: int:
	get:
		return _pget(&"some_prop")
	set(value):
		_pset(&"some_prop", value)

# 两行样板（类名自引用）
static func of(obj) -> IMyInterface:
	return GSInterface.make_view(IMyInterface, obj)

static func is_implemented_by(obj: Object) -> bool:
	return GSInterface.implements(obj, IMyInterface)
```

契约收集规则：接口脚本（含父接口链）中声明的全部**实例**方法（跳过静态、`_` 前缀、
`@` 属性访问器）与成员属性（跳过 `_` 前缀）即为契约；实现类只要同名同参可用即可。

## 为什么不用原生 `is`？

GDScript 的 `is` 运算符由引擎在编译期解析类型层级，不可重载：

- `some_node is IHealth` —— 两者类型不相关时**直接是编译错误**（不是 false）
- 经 Variant 绕过后运行期**恒为 false**（接口不在对象的继承链里）

因此接口判断必须走自定义方法（本插件提供的 `implements` / `is_a` / `is_implemented_by`）。
这是引擎级限制，不改引擎无法让 `is` 支持鸭子接口——按约定放弃改引擎路线。
唯一的例外：**视图包装壳是真正的接口实例**，`IHealth.of(obj) is IHealth` 原生成立。

## 原理

接口脚本的实例即「视图包装壳」：继承接口脚本本身，持有 `_target`（具体实现对象）。
- 接口方法桩体 = 转发代码：视图上调用时把调用转发到 `_target` 的同名方法；
- 静态类型分析看到的是接口签名（方法/属性都真实存在），因此**零警告**；
- 返回类型被引擎运行时校验（GDScript 4 对返回值做运行时类型检查），恰好构成边界签名强制。

## 限制与注意

1. **视图 ≠ 原对象**：`h == obj` 为 false；需要原对象时用 `h._target`。
   每次 `of()` 创建一个轻量 RefCounted 壳；热循环中请把视图缓存到变量。
2. **判断与调用分离**：判断用原对象或视图皆可（视图自动解包）；
   调用接口方法请通过视图（对原对象直接调接口方法仍会触发引擎警告，这是静态类型系统的本义）。
3. **不要 `free()` 视图**（RefCounted，自动释放）；视图是壳，生命周期不影响原对象。
4. 字符串形式的接口名查找（`is_a(obj, "IMyInterface")`）依赖引擎运行时暴露全局类列表
   （`ProjectSettings["_global_script_classes"]`），部分版本/导出环境下可能为空；
   **推荐总是传入 class_name 引用本身**（`is_a(obj, IMyInterface)`）。
5. 契约检查为方法名 + 属性存在性（鸭子类型）；未实现时调用会立即报
   「接口契约违反」错误并返回 null。
6. 异步方法（`await`）经转发仍可工作，但返回值语义与直接调用略有差异，复杂协程接口请先验证。

## 目录结构

```
addons/gdscript_interfaces/
├── plugin.cfg              # 插件描述（纯运行时插件，无需在编辑器中启用也可用）
├── gs_interface.gd         # 基类 GSInterface（全部实现）
├── examples/               # 示例接口 + 示例实现类（可随意删除）
│   ├── interfaces/i_nameable.gd
│   ├── interfaces/i_health.gd
│   ├── interfaces/i_mortal.gd   # 接口继承示例
│   ├── monster.gd
│   └── zombie.gd
└── tests/run_tests.gd      # 自测（headless 运行）
```

自测：
```
godot --headless --path . -s res://addons/gdscript_interfaces/tests/run_tests.gd
```

兼容性：Godot 4.4+（本项目 4.7）。
