// ملف build.gradle.kts الرئيسي

import org.gradle.api.tasks.Delete

// 1️⃣ كل المشاريع تستخدم المستودعات الرسمية
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// 2️⃣ تغيير مكان مجلد build الرئيسي لمجلد خارجي لتقليل مشاكل التخزين
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

// 3️⃣ تغيير مكان مجلد build لكل المشاريع الفرعية
subprojects {
    project.layout.buildDirectory.set(newBuildDir.dir(project.name))
}

// 4️⃣ التأكد إن المشاريع الفرعية بتتقيم بعد مشروع :app
subprojects {
    project.evaluationDependsOn(":app")
}

// 5️⃣ تعريف task تنظيف آمن لمجلد build
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
