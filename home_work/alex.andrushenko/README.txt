Создал namespace с именем "aaa" - namespace.yaml

Создал EBS командой aws ec2 create-volume --region us-west-2 --availability-zone us-west-2a --size 5
Использовал статический persistent volume, потому что при динамическом ругалось на плагин.
Это не очень удачная идея, потому что появилось ограничение, что pod может быть запущен только на ноде, расположеной в availability-zone us-west-2a (эту привязку внес в deployment.yaml).
Использовал для домашнего задания генерацию самоподписного сертификата, поэтому после создания сервиса добавлять в файл hosts его внешинй IP, чтобы резолвилось правильно тестовое имя.
И обавлял каждое пересоздание деплоя новый сгенерированный сертификат в рутовые, чтобы докер не ругался.

Порядок запуска:
kubectl apply -f pv.yaml
kubectl apply -f pvc.yaml
kubectl apply -f configmap.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

Проверил, что после пересоздания деплоя запушенный образ сохраняется.

После всех экспериментов почистил все созданные мной ресурсы kubernetes, кроме своего namespace.

Также удалил EBS командой aws ec2 delete-volume --volume-id vol-03080ab6e36bf3a0d
